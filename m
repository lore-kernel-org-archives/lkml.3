Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab3E3Tnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:43:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43051 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759885Ab3E3Tnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:43:31 -0400
Date: Thu, 30 May 2013 15:43:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jaroslav Kysela <perex@perex.cz>
cc: Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
In-Reply-To: <51A79F25.6040007@perex.cz>
Message-ID: <Pine.LNX.4.44L0.1305301540500.887-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Jaroslav Kysela wrote:

> Date 30.5.2013 20:14, Alan Stern wrote:
> > On Wed, 29 May 2013, Joe Perches wrote:
> > 
> >> On Wed, 2013-05-29 at 15:27 -0400, Alan Stern wrote:
> >>> Has there been any thought of improving snd_printk(), or even better,
> >>> changing the call sites to use the dev_*() routines instead?
> >>
> >> Perhaps better would be to add and use some combination of
> >> type specific logging message functions/macros like:
> >>
> >> void snd_<level>(const struct snd_device *dev, const char *fmt, ...)
> >> void snd_card_<level>(const struct snd_card *card, const char *fmt, ...)
> >> void snd_ac97_<level>(const struct snd_ac97 *ac97, const char *fmt, ...)
> >>
> >> allowing NULL as the type pointer when necessary/appropriate.
> > 
> > Almost anything would be better than the current situation.  The only 
> > enhancement provided by CONFIG_SND_VERBOSE_PRINTK is to print the 
> > filename and line number, which is relatively unhelpful (unless there 
> > are multiple copies of the same message in several places).
> 
> I don't think that it's useless to see the origin of the source message
> from the first glance. It may be improved, of course, but adding more
> and more functions with minor benefits is another step to another hell.

Maybe so.  However, including the device and driver names in the log 
messages is a major benefit, not a minor one.

I'd be happy to have just a snd_<level> family of functions, with 
snd_printk and snd_printd deprecated.  Does anybody object?

Alan Stern

