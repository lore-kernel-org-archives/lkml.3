Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaKDS2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:28:11 -0500
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:48037 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751073AbaKDS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:28:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3868:3872:3874:4321:4384:4385:4395:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast21_6363ce460074e
X-Filterd-Recvd-Size: 2040
Message-ID: <1415125681.23168.1.camel@perches.com>
Subject: Re: [PATCH] ALSA: echoaudio: cleanup of unnecessary messages
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 04 Nov 2014 10:28:01 -0800
In-Reply-To: <1415125074-28006-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415125074-28006-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 23:47 +0530, Sudip Mukherjee wrote:
> commit "b5b4a41b392960010fccf1f9ccf8334d612bd450" was dereferencing
> chip after it has been freed. This patch fixes that and at the same
> time removes some debugging messages, which are unnecessary, as they
> are just printing information about entry and exit from a function.
> This information we can easily get from ftrace.

Mostly true.

> diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
[]
> @@ -763,10 +755,8 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
>  	spin_lock(&chip->lock);
>  	switch (cmd) {
>  	case SNDRV_PCM_TRIGGER_RESUME:
> -		dev_dbg(chip->card->dev, "pcm_trigger resume\n");
>  	case SNDRV_PCM_TRIGGER_START:
>  	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> -		dev_dbg(chip->card->dev, "pcm_trigger start\n");
>  		for (i = 0; i < DSP_MAXPIPES; i++) {
>  			if (channelmask & (1 << i)) {
>  				pipe = chip->substream[i]->runtime->private_data;

These may not be useful but this switch state information
can't be got from ftrace.


