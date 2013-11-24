Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3KXBDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 20:03:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34978 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3KXBDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 20:03:07 -0500
Date: Sun, 24 Nov 2013 01:02:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-fbdev@vger.kernel.org, "'Kyungmin Park'" <kmpark@infradead.org>,
        kay@vrfy.org, Jingoo Han <jg1.han@samsung.com>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [ibm-acpi-devel] [PATCH] video: backlight: Remove backlight
 sysfs uevent
Message-ID: <20131124010257.GA6376@srcf.ucam.org>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
 <20131122113601.GB27196@khazad-dum.debian.net>
 <20131122171556.GA15680@srcf.ucam.org>
 <20131124004015.GA19499@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124004015.GA19499@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 10:40:15PM -0200, Henrique de Moraes Holschuh wrote:
> On Fri, 22 Nov 2013, Matthew Garrett wrote:
> > We have userspace that relies on uevents of type 
> > BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
> > on uevents of type BACKLIGHT_UPDATE_SYSFS.
> 
> Any OSD application would have to rely on both uevent types, or it is broken
> (and to test that, just write a level to sysfs and watch the OSD app fail to
> tell you about the backlight level change...)

Right, OSDs are supposed to respond to keypresses, not arbitrary changes 
of backlight. If the user's just echoed 8 into brightness, they know 
they set the brightness to 8 - they don't need an OSD to tell them that. 
BACKLIGHT_UPDATE_HOTKEY is when the firmware itself has changed the 
brightness in response to a keypress, and so reporting the keypress 
would result in additional backlight changes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
