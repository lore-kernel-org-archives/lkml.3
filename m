Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbbAWAoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:44:39 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:33277 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbbAWAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:44:35 -0500
Date: Fri, 23 Jan 2015 01:44:29 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv5 2/2] INPUT: Introduce generic trigger/LED pairs to
 input LEDs
Message-ID: <20150123004429.GD3123@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	akpm@linux-foundation.org, jslaby@suse.cz,
	Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <20141226232116.GA5069@type>
 <20150123001038.GA2940@type.youpi.perso.aquilenet.fr>
 <20150123003011.GC3123@type.youpi.perso.aquilenet.fr>
 <1756449.aIckN0M451@dtor-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1756449.aIckN0M451@dtor-glaptop>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Thu 22 Jan 2015 16:37:02 -0800, a écrit :
> On Friday, January 23, 2015 01:30:11 AM Samuel Thibault wrote:
> > Samuel Thibault, le Fri 23 Jan 2015 01:10:38 +0100, a écrit :
> > > Dmitry Torokhov, le Sun 04 Jan 2015 15:28:38 -0800, a écrit :
> > > > > +	dev = cdev->dev->platform_data;
> > > > 
> > > > Umm, platform data is not the best place for storing this. Why not
> > > > drvdata?
> > > 
> > > Ah, actually led_classdev already makes use of it, see the
> > > device_create_with_groups call in led_classdev_register.
> > 
> > Actually I'd say it makes sense to be using the platform_data field:
> > from the point of view of the led object, the input object is indeed
> > something like a platform.
> 
> No, platform data is what difefrentiates an arm board from another arm board, 
> or an x86 or mips one.

>From the point of view of a device connected to that board, yes. But
from the point of view of LEDs connected to a keyboard, the platform is
the keyboard.

Samuel
