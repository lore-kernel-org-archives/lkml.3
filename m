Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbbABULZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:11:25 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:48824 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABULX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:11:23 -0500
Date: Fri, 2 Jan 2015 21:11:17 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv5 0/2] INPUT: Route keyboard LEDs through the generic
 LEDs layer
Message-ID: <20150102201117.GD25336@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
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
 <20150102195350.GB27538@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150102195350.GB27538@amd>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Fri 02 Jan 2015 20:53:51 +0100, a écrit :
> input4::capsl/trigger was none by default, that can't be right, right?

Indeed. And I don't see how it can be that way, since the input4::capsl
LED and the input4-capsl trigger get initialized at the same time in
input_led_connect... (and the order does not matter since both will
try to connect to the other on registration).

> I tried putting kbd-capslock and input4-capsl there, but that did not
> seem to help.

That should have.

> It works with heartbeat trigger, but not with input4-numl
> trigger.

It should have worked with input4-numl too.

> vt::capsl/brightness controls capslock led, even when
> input4-capsl/trigger is set to input4-numl.

It shouldn't.

> Confused,

I guess I'm even more.  I had tested everything that you have described,
without any issue, on both an internal laptop keyboard and an external
USB keyboard, and have tested again just now, with the same success.

Which hardware setup do you have, more precisely?

Samuel
