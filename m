Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3ARPI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:08:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39041 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3ARPIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:08:25 -0500
Message-ID: <50F96555.2020402@ti.com>
Date: Fri, 18 Jan 2013 17:08:05 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 06/22] mfd: omap-usb-tll: introduce and use mode_needs_tll()
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-7-git-send-email-rogerq@ti.com> <20130118150242.GF23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130118150242.GF23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 05:02 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 18, 2013 at 02:17:09PM +0200, Roger Quadros wrote:
>> +/* only PHY and UNUSED modes don't need TLL */
>> +#define omap_usb_mode_needs_tll(x)	((x != OMAP_USBHS_PORT_MODE_UNUSED) &&\
>> +					 (x != OMAP_EHCI_PORT_MODE_PHY))
> 
> Growl.
> 
> These parens do not make anything safer at all - they just obfuscate.  The
> safe version of the above macro would have been:
> 
> #define omap_usb_mode_needs_tll(x)	((x) != OMAP_USBHS_PORT_MODE_UNUSED &&\
> 					 (x) != OMAP_EHCI_PORT_MODE_PHY)
> 
> If you're going to use a macro argument in an expression, it needs parens.
> Simple expressions like a != b && c != d do _not_ need parens.
> 

Yikes, that was brain dead stuff from me ;). Will fix.

cheers,
-roger
