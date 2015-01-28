Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbbA1U0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:26:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142AbbA1U0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:26:24 -0500
Date: Wed, 28 Jan 2015 09:50:40 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20150128095040.GI14516@opensource.wolfsonmicro.com>
References: <20150128130047.2311c637@canb.auug.org.au> <20150128090935.GH14516@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128090935.GH14516@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:09:35AM +0000, Charles Keepax wrote:
> On Wed, Jan 28, 2015 at 01:00:47PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the sound-asoc tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > sound/soc/codecs/arizona.c: In function 'arizona_out_ev':
> > sound/soc/codecs/arizona.c:738:57: error: 'struct snd_soc_dapm_widget' has no member named 'codec'
> >   struct arizona_priv *priv = snd_soc_codec_get_drvdata(w->codec);
> >                                                          ^
> > 
> > Caused by commit 054e1b489227 ("ASoC: arizona: Add delay for output
> > disable") interacting with commit 96da4e5b2e1d ("ASoC: Remove codec
> > field from snd_soc_dapm_widget").  It needed to be fixed up in merge
> > commit 7659e0ab1afa ("Merge remote-tracking branches
> > 'asoc/topic/ad193x', 'asoc/topic/alc5632', 'asoc/topic/arizona' and
> > 'asoc/topic/atmel' into asoc-next").
> > 
> > I have used the sound-asoc tree from next-20150127 for today.
> > -- 
> 
> Very sorry guys my fault, not sure how that slipped through. Mark
> do you want an incremental fix or shall I respin the two patches
> in question?

Ah... ok I think I just timed my patch very badly in relation to
Lar's changes and it was building here so I failed to notice the
error. I see you have fixed it in the merge are you happy to go
with that solution?

Thanks,
Charles
