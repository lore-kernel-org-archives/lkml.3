Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaBJNbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:24 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55932 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbaBJNbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:15 -0500
Message-ID: <1392039072.3585.15.camel@x220>
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 14:31:12 +0100
In-Reply-To: <20140210114154.GQ1757@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-15-git-send-email-richard@nod.at>
	 <20140210114154.GQ1757@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 13:31:12.0720 (UTC) FILETIME=[5DAC6D00:01CF2664]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 11:41 +0000, Mark Brown wrote:
> On Sun, Feb 09, 2014 at 07:47:52PM +0100, Richard Weinberger wrote:
> Please fix whatever script you're using to generate your mails, it's
> generating corrupt headers.

I think Richard's mail didn't end up on lkml. But it's pretty clear what
it must have looked like.

> >  config SND_SOC_SAMSUNG_SMDK_WM9713
> >  	tristate "SoC AC97 Audio support for SMDK with WM9713"
> > -	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310 || MACH_SMDKC210)
> > +	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310)
> 
> Like I said to Paul this isn't fixing the actual issue - think about why
> the symbol was there in the first place and why it was removed.  There
> is a problem here but this would make it less likely that it would be
> properly fixed.

Would you mind going through this one step at a time, just to make sure
_I_ understand what it is that you'd like to see?

If so, to be absolutely sure we start from the same point: do you agree
that the above line now effectively reads
    depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110 || false || false)

because there's neither a Kconfig symbol MACH_SMDKV310 nor a Kconfig
symbol MACH_SMDKC210?


Paul Bolle

