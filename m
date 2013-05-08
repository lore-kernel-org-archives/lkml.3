Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3EHIab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:30:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62611 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3EHIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:30:28 -0400
Date: Wed, 8 May 2013 10:30:17 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/6] ASoC: ab8500-codec: Add missing ad_to_slot
 definitions
Message-ID: <20130508083017.GB1526@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-2-git-send-email-fabio.baltieri@linaro.org>
 <20130508075328.GF3102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508075328.GF3102@gmail.com>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 08:53:28AM +0100, Lee Jones wrote:
> I'm sure this is just me, but:
> 
> >    0 to  7 corresponds to AD_OUTx slots
> > char * const enum_ad_to_slot_map[] = {"AD_OUT1",    0
>                                                       1..5 ???
> >  					"AD_OUT7",    6
> >  					"AD_OUT8",    7

I'm a bit confused... the first one was from the diff header, while OUT7 and
OUT8 are context lines, so 1 to 5 are already there but not shown in the
patch.  The final array is like:

static const char * const enum_ad_to_slot_map[] = {"AD_OUT1",
                                        "AD_OUT2",
                                        "AD_OUT3",
                                        "AD_OUT4",
                                        "AD_OUT5",
                                        "AD_OUT6",
                                        "AD_OUT7",
                                        "AD_OUT8",
                                        "zeroes",
                                        "zeroes",
                                        "zeroes",
                                        "zeroes",
                                        "tristate",
                                        "tristate",
                                        "tristate",
                                        "tristate"};

Is it ok?

Fabio

> >    8 to 11 corresponds to zero output
> >  					"zeroes",     8
> > +					"zeroes",     9
> > +					"zeroes",     10
> > +					"zeroes",     11
> >   12 to 15 sets the output in tristate mode
> > +					"tristate",   12
> > +					"tristate",   13
> > +					"tristate",   14
> >  					"tristate"};  15
> 
> 
> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

-- 
Fabio Baltieri
