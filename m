Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaIIJYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:24:53 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35435 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbaIIJYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <540DBE43.50403@ti.com>
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
	<1409758637-28654-2-git-send-email-gabriel.fernandez@linaro.org>
	<540DBE43.50403@ti.com>
Date: Tue, 9 Sep 2014 11:24:50 +0200
Message-ID: <CAG374jDLuwxYfxqY9UGt7+5gqo7eZxFn-=ehEpRJQfyCeWG3fQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

ok will be fix to v3

BR

Gabriel

On 8 September 2014 16:33, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 03 September 2014 09:07 PM, Gabriel FERNANDEZ wrote:
>> The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
>> or USB3 devices.
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  .../devicetree/bindings/phy/phy-miphy28lp.txt      | 126 +++++++++++++++++++++
>>  1 file changed, 126 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>> new file mode 100644
>> index 0000000..5e307af
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>> @@ -0,0 +1,126 @@
>> +STMicroelectronics STi MIPHY28LP PHY binding
>> +============================================
>> +
>> +This binding describes a miphy device that is used to control PHY hardware
>> +for SATA, PCIe or USB3.
>> +
>> +Required properties (controller (parent) node):
>> +- compatible : Should be "st,miphy28lp-phy"
>> +- st,syscfg  : Should be a phandle of the system configuration register group
>> +               which contain the SATA, PCIe or USB3 mode setting bits
>> +
>> +Required nodes       :  A sub-node is required for each channel the controller
>> +                provides. Address range information including the usual
>> +                'reg' and 'reg-names' properties are used inside these
>> +                nodes to describe the controller's topology. These nodes
>> +                are translated by the driver's .xlate() function.
>> +
>> +Required properties (port (child) node):
>> +- #phy-cells : Should be 1 (See second example)
>> +               Cell after port phandle is device type from:
>> +                     - MIPHY_TYPE_SATA
>> +                     - MIPHY_TYPE_PCI
>> +                     - MIPHY_TYPE_USB3
>> +- reg                : Address and length of the register set for the device
>> +- reg-names  : The names of the register addresses corresponding to the registers
>> +               filled in "reg". Is can also contain the offset of the system configuration
>
> %s/Is/It
>
> Thanks
> Kishon
