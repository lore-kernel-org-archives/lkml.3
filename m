Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaFZFhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:37:41 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45404 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaFZFhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <1403719007-9352-3-git-send-email-kishon@ti.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
	<1403719007-9352-3-git-send-email-kishon@ti.com>
Date: Thu, 26 Jun 2014 11:07:38 +0530
Message-ID: <CAHM4w1mMT5een4pAFb9s1JENm=j1W2yMPYdO+OdBhAy0wcRdjw@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: designware: use untranslated address while
 programming ATU
From: Pratyush Anand <pratyush.anand@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mohit KUMAR DCG <mohit.kumar@st.com>, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Pratyush ANAND <pratyush.anand@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

 Few things, if you can help me to understand:

On Wed, Jun 25, 2014 at 11:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> address. So whenever the cpu issues a read/write request, the 4 most
> significant bits are used by L3 to determine the target controller.
> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> the outbound translation window the *base* should be programmed as 0x000_0000.
> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> we have programmed in the translation window with base as 0x000_0000.
>
> This is needed when the dt node is modelled something like below
> axi {
>         compatible = "simple-bus";
>         #size-cells = <1>;
>         #address-cells = <1>;
>         ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
>                   0x51000000 0x51000000 0x3000>;
>         pcie@51000000 {
>                 reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
>                 reg-names = "config", "ti_conf", "rc_dbics";

So for DRA7, config base which will be coming from reg property should
be 0x1000 and size 0x2000, no?

>                 #address-cells = <3>;
>                 #size-cells = <2>;
>                 ranges = <0x81000000 0 0          0x03000 0 0x00010000

range type 0x81000000 tells that it is IO

>                           0x82000000 0 0x20013000 0x13000 0 0xffed000>;

range type 0x81000000 tells that it is mem


>         };
> };
>
> Here the CPU address for configuration space is 0x20013000 and the controller
> address for configuration space is 0x13000. The controller address should
be

If above understanding is correct then:

Aren't these addresses(0x20013000  and 0x13000) from mem space
instead of configuration space.

If yes, then how can you get two addresses (CPU and Controller address)
from reg property for configuration space?

~Pratyush
