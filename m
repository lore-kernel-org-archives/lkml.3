Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaEGJWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:22:11 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37936 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbaEGJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:22:07 -0400
Message-ID: <5369FB36.7040404@gmail.com>
Date: Wed, 07 May 2014 11:21:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 00/20] USB support for Armada 38x and Armada 375
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com> <loom.20140507T102941-222@post.gmane.org>
In-Reply-To: <loom.20140507T102941-222@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding back the original Cc-List]

On 05/07/2014 10:33 AM, Hans de Goede wrote:
> Hi Gregory,
>
> Gregory CLEMENT <gregory.clement <at> free-electrons.com> writes:
>
>> This patch set adds the USB support for the Armada 38x Armada
>> 375. These SoCs use an xHCI but still need specific initialization,
>> mainly to setup the windows memory on the mbus. They also use the same
>> controller that the other mvebu SoC for EHCI.
>
> <snip>
>
>> Gregory CLEMENT (20):
>>    usb: ehci-orion: Fix clock reference leaking
>>    usb: ehci-orion: Add the optional PHY support
>
> If you're using a proper phy driver, do you really need a soc specific ehci
> driver? I've spend a lot of time during the last release cycle to make
> ehci-platform a lot more generic, including adding (optional) phy support to
> it. It would be great if the new Armada SoCs could use ehci-platform instead
> of extending ehci-orion to cover more models (ideally most ehci-foo drivers
> would go away completely). I've no idea how feasible it is to use
> ehci-platform in your case, but IMHO it should at least be considered.

Hans,

unfortunately we currently have no USB-PHY driver for the other mvebu
SoCs. I have started some code grabbing for barebox bootloader and plan
to add proper USB-PHYs for Linux later.

There is one thing very specific to mvebu SoCs, which is the mbus:
you need to setup upstream memory windows for the usb bus master.
 From my current understanding, that will require at least a minimal
stub to remain for ehci-orion.

I do think that most of the stuff in ehci-orion can (and should) be
replaced with ehci-platform then. So, we definitely consider reusing
the generic foo-platform drivers on all opportunities but IMHO we are
not yet ready for it.

Sebastian

