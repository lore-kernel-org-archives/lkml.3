Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaKEHCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:02:04 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56027 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKEHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:02:01 -0500
Date: Wed, 5 Nov 2014 12:31:50 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] ALSA: echoaudio: cleanup of unnecessary messages
Message-ID: <20141105070150.GA4881@sudip-PC>
References: <1415125074-28006-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1415125681.23168.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415125681.23168.1.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:28:01AM -0800, Joe Perches wrote:
> On Tue, 2014-11-04 at 23:47 +0530, Sudip Mukherjee wrote:
> > commit "b5b4a41b392960010fccf1f9ccf8334d612bd450" was dereferencing
> > chip after it has been freed. This patch fixes that and at the same
> > time removes some debugging messages, which are unnecessary, as they
> > are just printing information about entry and exit from a function.
> > This information we can easily get from ftrace.
> 
> Mostly true.
> 
> > diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
> []
> > @@ -763,10 +755,8 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
> >  	spin_lock(&chip->lock);
> >  	switch (cmd) {
> >  	case SNDRV_PCM_TRIGGER_RESUME:
> > -		dev_dbg(chip->card->dev, "pcm_trigger resume\n");
> >  	case SNDRV_PCM_TRIGGER_START:
> >  	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> > -		dev_dbg(chip->card->dev, "pcm_trigger start\n");
> >  		for (i = 0; i < DSP_MAXPIPES; i++) {
> >  			if (channelmask & (1 << i)) {
> >  				pipe = chip->substream[i]->runtime->private_data;
> 
> These may not be useful but this switch state information
> can't be got from ftrace.
is this information required? trigger callback will be called everytime pcm is started, stopped or paused. then log will be full of just these messages.
if it is required then i can send a v2, if not required then also i can send another cleanup patch to clear the other prints in the
switch-case of other devices in echoaudio.

thanks
sudip	

> 
> 
