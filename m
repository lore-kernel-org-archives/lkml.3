Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3EaHGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:06:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46406 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751161Ab3EaHGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:06:08 -0400
Message-ID: <1369983967.10556.48.camel@joe-AO722>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Alan Stern <stern@rowland.harvard.edu>,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 31 May 2013 00:06:07 -0700
In-Reply-To: <s5hr4gniri4.wl%tiwai@suse.de>
References: <Pine.LNX.4.44L0.1305301411370.1137-100000@iolanthe.rowland.org>
	 <51A79F25.6040007@perex.cz> <s5hr4gniri4.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 08:37 +0200, Takashi Iwai wrote:
> It's a problem only with snd_printk(), as CONFIG_SND_VERBOSE_PRINTK
> influences on the behavior of snd_printk() and not on the debug prints
> with snd_printd() & co.

Are you're perhaps confused about how CONFIG_SND_VERBOSE_PRINTK
works with or varies between snd_printd and snd_printk?

#if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
__printf(4, 5)
void __snd_printk(unsigned int level, const char *file, int line,
		  const char *format, ...);

...

#define snd_printk(fmt, args...) \
	__snd_printk(0, __FILE__, __LINE__, fmt, ##args)

#ifdef CONFIG_SND_DEBUG
[...]
#define snd_printd(fmt, args...) \
	__snd_printk(1, __FILE__, __LINE__, fmt, ##args)

I don't see a difference.

> Hence, the goal we should achieve is rather to drop
> CONFIG_SND_VERBOSE_PRINTK.  *This* is the useless thing.

Maybe.

> Meanwhile, many snd_printk() messages might start looking annoying
> with the extra information.  If so, such lines should be replaced with
> the standard prints like dev_*().  I think almost all snd_printk()
> like below are better replaced with standard ones.

below?  Was there something that was supposed to be below?
Are you referring to the KERN_ERR/urb example above?

> So, alternatively, we can begin with replacing some snd_printk() with
> the standard functions, then dropping CONFIG_SND_VERBOSE_PRINTK.

Dropping CONFIG_SND_VERBOSE_PRINTK would simplify code a bit.

> I think most of snd_printd() and snd_printdd() can be kept as is.
> These are just debug messages, after all.

Some of those are emitted at levels other than KERN_DEBUG.
I think that odd.

