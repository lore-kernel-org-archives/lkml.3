Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaLQPot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:44:49 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60570 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLQPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:44:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Sneeker. Yeh" <Sneeker.Yeh@tw.fujitsu.com>
Cc: Sneeker Yeh <sneeker.yeh@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCH 1/3] usb: host: f_usb20ho: add support for Fujitsu ehci/ohci USB 2.0 host controller
Date: Wed, 17 Dec 2014 16:44:29 +0100
Message-ID: <2084132.xT3x4RUEre@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <830AC58E49A426478AC39824BC0FA915D8BB402BB7@fmpitwmsex01.fmpi.sea.css.fujitsu.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com> <94603263.7VVvg5Qn7O@wuerfel> <830AC58E49A426478AC39824BC0FA915D8BB402BB7@fmpitwmsex01.fmpi.sea.css.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:hnibytYt/i6DZPYSFDxwBa4DhfsnBvISto9T7iu5MZC1+g1DOMF
 1x8N60UC5LqshnFmsBxBViwI9wpXWzRXgaOP0Adi5uK7cZgvGWug0sGeNRyAwDq2W6uxtuB
 a66sZsViCB08KSqBepbLzYtI0pYzakwxEaNklLs15bXTgJDWhti9Qgr9rcw4DjwFjoTStXK
 pA921GZsVaWzb2jb7uZTg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 23:33:02 Sneeker. Yeh wrote:
> >
> >No need for playing games with child devices, just see how the other drivers do
> >it.
> 
> I am wondering if this is what you mentioned here? :
> Hcd21: f_usb20ho {
>         compatible = "fujitsu,f_usb20ho";
>         ...
>         Ehci {
>                 compatible = "generic-ehci";
>                 reg = <>;
>         }
>         ohci {
>                 compatible = "generic-ohci";
>                 reg = <>;
>         }
> }
> By doing that, I can just use of_platform_populate() to create platform device more gracefully,
> than using platform_device_xxx() those have been done in of_platform_populate().
> And also, managing register offset is totally done via dts description, not in the code.

What I mean is leaving out the fujitsu,f_usb20ho node entirely, just put the
two USB controllers on the bus directly and remove this driver.

	Arnd
