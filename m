Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaBRJYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:24:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbaBRJYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:24:31 -0500
Date: Tue, 18 Feb 2014 09:24:29 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, lars@metafoo.de, eric.y.miao@gmail.com,
        dmitry.torokhov@gmail.com, lgirdwood@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        peter.ujfalusi@ti.com, cw00.choi@samsung.com, myungjoo.ham@samsung.com,
        patches@opensource.wolfsonmicro.com, linux@arm.linux.org.uk,
        jarkko.nikula@bitmer.com
Subject: Re: [alsa-devel] [PATCH 04/15] ASoC: wm5100: Update locking around
	use of DAPM pin API
Message-ID: <20140218092429.GB18502@opensource.wolfsonmicro.com>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392655903-24537-5-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140218004729.GK2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218004729.GK2669@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:47:29AM +0900, Mark Brown wrote:
> On Mon, Feb 17, 2014 at 04:51:32PM +0000, Charles Keepax wrote:
> 
> > +		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "CP2");
> > +		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "SYSCLK");
> > +
> > +		mutex_unlock(&codec->dapm.card->dapm_mutex);
> > +
> >  		snd_soc_dapm_sync(&codec->dapm);
> 
> With all these patches it seems weird that we have to drop the lock to
> do the sync which will immediately retake it.  It's not broken but it
> looks off - it would be better to have a version of _sync() that we can
> call within the lock.

No problem to add a version of sync that can be called from
within the lock, should help out with Dimtry's comments as well.

> 
> Regarding the naming issue that Lars mentioned I think the current
> operations are probably fine but calling them _unlocked() meaning they
> don't do any locking (as distinct from the existing _locked() which take
> locks) might be OK.

Yeah that would be good, since my original aim here was to avoid
updating every single usage of these functions.

Thanks,
Charles
