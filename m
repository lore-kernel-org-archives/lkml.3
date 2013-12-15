Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3LONHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:07:42 -0500
Received: from www.prifuk.cz ([31.31.77.241]:41178 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab3LONHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:07:39 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: Joe Perches <joe@perches.com>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: Re: [RFC] Add ff-memless-next driver
Date: Sun, 15 Dec 2013 14:07:34 +0100
Message-ID: <5807033.13lmKIeEg9@geidi-prime>
User-Agent: KMail/4.11.4 (Linux/3.13.0-1-ARCHMOD; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1387073042.2276.21.camel@joe-AO722>
References: <20107437.IkYg87uJMY@geidi-prime> <1387073042.2276.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 of December 2013 18:04:02 Joe Perches wrote:
> On Sun, 2013-12-15 at 01:19 +0100, Michal Malý wrote:
> > diff --git a/drivers/input/ff-memless-next.c
> > b/drivers/input/ff-memless-next.c
> []
> 
> > +static inline s32 mlnx_clamp_level(const s32 level)
> > +{
> > +	return (level > 0x7fff) ? 0x7fff : ((level < -0x7fff) ? -0x7fff :
> > level);
> 
> 	clamp(level, -0x7fff, 0x7fff);
> []
> 
> > +static inline int mlnx_is_conditional(const struct ff_effect *effect)
> > +{
> > +	return (effect->type == FF_DAMPER) || (effect->type == FF_FRICTION) ||
> > (effect->type == FF_INERTIA) || (effect->type == FF_SPRING); +}
> 
> Maybe try to run your patch through scripts/checkpatch.pl
> 
> bool?
> 80 char line max? (true for the file, not just here)
> switch?
> 	switch (effect->type) {
> 	case FF_DAMPER:
> 	case FF_FRICTION:
> 	case FF_INERTIA:
> 	case FF_SPRING:
> 		return true;
> 	}
> 	return false;

Okay, thanks for the input. I found a problem regarding effect updating in the code anyway. I'll submit a corrected version of the patch once I'm sure it's fixed.

Michal
