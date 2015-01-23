Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbbAWAvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:51:23 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45256 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbbAWAvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:51:20 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv5 2/2] INPUT: Introduce generic trigger/LED pairs to input LEDs
Date: Thu, 22 Jan 2015 16:51:16 -0800
Message-ID: <4596566.1GHUcIZaFc@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-43-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20150123004429.GD3123@type.youpi.perso.aquilenet.fr>
References: <20141226232116.GA5069@type> <1756449.aIckN0M451@dtor-glaptop> <20150123004429.GD3123@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2015 01:44:29 AM Samuel Thibault wrote:
> Dmitry Torokhov, le Thu 22 Jan 2015 16:37:02 -0800, a écrit :
> > On Friday, January 23, 2015 01:30:11 AM Samuel Thibault wrote:
> > > Samuel Thibault, le Fri 23 Jan 2015 01:10:38 +0100, a écrit :
> > > > Dmitry Torokhov, le Sun 04 Jan 2015 15:28:38 -0800, a écrit :
> > > > > > +	dev = cdev->dev->platform_data;
> > > > > 
> > > > > Umm, platform data is not the best place for storing this. Why not
> > > > > drvdata?
> > > > 
> > > > Ah, actually led_classdev already makes use of it, see the
> > > > device_create_with_groups call in led_classdev_register.
> > > 
> > > Actually I'd say it makes sense to be using the platform_data field:
> > > from the point of view of the led object, the input object is indeed
> > > something like a platform.
> > 
> > No, platform data is what difefrentiates an arm board from another arm
> > board, or an x86 or mips one.
> 
> From the point of view of a device connected to that board, yes. But
> from the point of view of LEDs connected to a keyboard, the platform is
> the keyboard.

No. Please take a look at other users of platform data. Platform is the box we 
are running on, not parent device. Platform data is supposed to be constant,
not changing between driver runs.

Thanks.

-- 
Dmitry
