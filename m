Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3EaOZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:25:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41192 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751880Ab3EaOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:24:52 -0400
Date: Fri, 31 May 2013 10:24:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Takashi Iwai <tiwai@suse.de>
cc: Joe Perches <joe@perches.com>, Jaroslav Kysela <perex@perex.cz>,
        <alsa-devel@alsa-project.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
In-Reply-To: <s5ha9nbinre.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.44L0.1305311014330.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Takashi Iwai wrote:

> > I don't see the complexity/hell in adding functions
> > for specific types of struct * to reduce the complexity
> > of the code though.  Centralizing those indirections
> > into functions also generally reduces overall code size.
> 
> I don't mind to add the struct pointer to new snd_*() -- if we really
> introduce them.  The bigger question is whether we really need to
> introduce such, and if yes, what variants.  And for that, I don't
> think we need to add many functions.  Maybe snd_card_<level>() would
> be good.  But others don't seem to make sense to me (remember that I
> suggest dropping CONFIG_SND_VERBOSE_PRINTK).

struct snd_card contains pointers to two different devices: dev and 
card_dev.  Some contexts might want to use one of them for log messages 
while other contexts might want to use the other.

I guess defining snd_card_*() to use card->card_dev makes the most 
sense.  If some code wants to use card->dev instead, it can pass that 
as the first argument to dev_*().

The most commonly used levels seem to be err, warn, info, and dbg.  
Those ought to be enough.  In fact, you probably could getting along 
without warn -- just err, info, and dbg.

Alan Stern

