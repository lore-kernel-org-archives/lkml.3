Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3EaPeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:34:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41253 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752206Ab3EaPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:33:45 -0400
Date: Fri, 31 May 2013 11:33:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Takashi Iwai <tiwai@suse.de>
cc: Joe Perches <joe@perches.com>, Jaroslav Kysela <perex@perex.cz>,
        <alsa-devel@alsa-project.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
In-Reply-To: <s5hwqqf1an3.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.44L0.1305311131450.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Takashi Iwai wrote:

> > struct snd_card contains pointers to two different devices: dev and 
> > card_dev.  Some contexts might want to use one of them for log messages 
> > while other contexts might want to use the other.
> 
> Yes, there are some corner cases, indeed.
> 
> Also, another expected problem is that neither card->card_dev nor
> card->dev are set when snd_card_err() is called.  Many drivers set the
> device pointers at the late stage just before the device
> registration.  So, systematic replacements won't work as expected in
> many cases.  (The same is applied for replacement with dev_*(), too.)

Given that the drivers would have to be edited to fix up the snd_printk 
calls, the device pointer assignments can be moved to an earlier stage 
at the same time.  But doing this would require understanding how the 
driver works to some extent; it couldn't be done blindly.

Alan Stern

