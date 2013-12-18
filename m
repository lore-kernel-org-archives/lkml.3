Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3LRTRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:17:02 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:5852 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755766Ab3LRTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:16:59 -0500
Date: Wed, 18 Dec 2013 14:16:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] localmodconfig / ALSA: hda - Have codecs be
 disabled by localmodconfig
Message-ID: <20131218141656.7dfae8fc@gandalf.local.home>
In-Reply-To: <s5hd2kuj7yw.wl%tiwai@suse.de>
References: <20131218173519.265509723@goodmis.org>
	<s5hd2kuj7yw.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 20:05:11 +0100
Takashi Iwai <tiwai@suse.de> wrote:

 
> Well, as mentioned in the mail thread, I'm afraid that people don't
> like to see yet doubled kconfig items just for workarounds by this
> approach.  So it'd be likely better not to restrict but just let users
> choose tristate.  I already submitted the patches (the same ones as
> attached before) to alsa-devel ML.

Sure, that's why I added the RFC.

> 
> Another thing we may add is a warning like:
> 
> ================================================================
> config SND_HDA_CODEC_REALTEK
> 	tristate "Build Realtek HD-audio codec support"
> 	select SND_HDA_GENERIC
> 	help
> 	  Say Y or M here to include Realtek HD-audio codec support in
> 	  snd-hda-intel driver, such as ALC880.
> 
> comment "Set to Y if you want auto-loading the codec driver"
> 	depends on SND_HDA_CODEC_REALTEK && SND_HDA_INTEL != SND_HDA_CODEC_REALTEK
> ================================================================
> 
> The comment won't break make localmodconfig, right?

Nope, it shouldn't affect localmodconfig at all.

> This should be intuitive enough for avoiding pitfalls, I hope.

But the first patch still needs to be added. I'll just send that out by
itself.

Thanks,

-- Steve
