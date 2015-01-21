Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbAUPVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:21:42 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:24330
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbbAUPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:21:34 -0500
X-IronPort-AV: E=Sophos;i="5.09,442,1418079600"; 
   d="scan'208";a="97218249"
Date: Wed, 21 Jan 2015 16:21:12 +0100
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
Message-ID: <20150121152112.GA24789@type.bordeaux.inria.fr>
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

Hello,

Pavel Machek, le Fri 02 Jan 2015 20:53:51 +0100, a écrit :
> > Here is v5 coming, with separate patches for the kbd and the input
> > parts.
> 
> After booting with this, capslock led does not seem to work on text
> console.
> 
> input4::capsl/trigger was none by default, that can't be right, right?
> 
> I tried putting kbd-capslock and input4-capsl there, but that did not
> seem to help.
> 
> It works with heartbeat trigger, but not with input4-numl
> trigger. (But numlock led works ok with that trigger, weird).
> 
> vt::capsl/brightness controls capslock led, even when
> input4-capsl/trigger is set to input4-numl.

I have just tried what you described on a thinkpad lenovo T500, without
any problem, except that the thinkpad BIOS does a couple of funky
things:

- depending on the numlock bios setting, the numlock led will be
  driven by the OS (synchronized mode) or handled internally in the BIOS
  (independent mode).
- in synchronized mode, whenever the internal numlock led is lit, the
  right part of the internal keyboard acts as the keypad keys.

Samuel
