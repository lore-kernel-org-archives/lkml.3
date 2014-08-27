Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032AbaH0Qgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:36:37 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:46354 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaH0Qge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <53FB8A8C.8040107@wwwdotorg.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
	<1408381705-3623-4-git-send-email-abrestic@chromium.org>
	<53FB8A8C.8040107@wwwdotorg.org>
Date: Wed, 27 Aug 2014 09:36:33 -0700
X-Google-Sender-Auth: F7Ck0VL9FwY4Vt9C9e1k-KuS--8
Message-ID: <CAL1qeaGHuMegpeyumD8GrFRmeufkiiUygAdqu1ECHrfSkixwOQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] of: Update Tegra XUSB pad controller binding for USB
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 12:12 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>>   - #phy-cells: Should be 1. The specifier is the index of the PHY to
>> reference.
>>     See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list of valid
>> values.
>> +- mboxes: Must contain an entry for the XUSB PHY mailbox channel.
>> +  See ../mailbox/mailbox.txt for details.
>
>
> Can we require the mbox-names property here, so that everything is looked up
> by names. I know that the proposed mbox binding states that using indexes is
> preferred over names, but that's just silly considering that names are
> widely used in most other similar bindings, and are much easier to extend in
> a backwards compatible fashion in the face of optional entries. As such, I'd
> prefer that all Tegra bindings use foo-names properties where they exist.

Sure, will do.

>> +Optional properties:
>> +-------------------
>> +- vbus-otg-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
>
>
> Why "-otg"? It's quite possible to have a regulator for VBUS even on systems
> that don't support OTG, but rather simply have the ability to turn VBUS off.

Because they're the VBUS supplies for the OTG 'lanes'.  It doesn't
really add anything, so I'll omit the "-otg".
