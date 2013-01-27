Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3A0EBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 23:01:09 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42822 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3A0EBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 23:01:06 -0500
Date: Sun, 27 Jan 2013 05:01:04 +0100
From: Andreas Mohr <andi@lisas.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dick Streefland <dick@streefland.net>
Subject: Re: [PATCH 0/3] Include kernel config by default
Message-ID: <20130127040104.GA5422@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359207268-9340-1-git-send-email-holler@ahsoftware.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[CC'd extract-ikconfig creator]

> I've seen too many systems where the config to build the used kernel got
> lost and people were unable to diagnose problems or to rebuild a modified
> or updated kernel. It's a subject which worries me since several years.

I'm strongly in favour of such a change. The actual config is simply very
important for traceability.
In a recent case of mine I simply built the kernel on an external HDD
and did not copy the config file on deployment (e.g. to /boot).
With that kernel build tree then unavailable,
I then realized that this kernel fortunately did have IKCONFIG_PROC enabled,
thus configs.ko was available for (re-)use.

However an argument could be made that the default setting
should be the bare-minimum needed to provide this information source
in emergency cases (i.e., a manual run of scripts/extract-ikconfig would
be in order and easily acceptable).

$ ls -l kernel/configs.ko 
-rw-r--r-- 1 root root 35788 Jan 25 18:43 kernel/configs.ko

IMHO more than 32kB for the proc/config.gz module arguably is
quite a bit of code for it to painlessly be enabled by default
given availability of other methods of retrieval.

However, now that I think of it ISTR that using extract-ikconfig
on my bzImage did NOT work yet loading configs.ko of the same install
successfully provided a /proc/config.gz. Huh??
If this is the case, then one or both of these things ought to be done:
- make extract-ikconfig not fail in such a case
- [failing the prior one] enable /proc/config.gz by default, too

Aww wait: I was mistaken in thinking that the config data is statically
included in the kernel and configs.ko then is about providing /proc
only. This not being the case (config data itself is provided by *module*,
too) explains both my extract-ikconfig failure on the static kernel
image and the size of configs.ko, so additionally enabling
/proc/config.gz in this module most likely is a non-issue.

However, this means that extract-ikconfig is missing a user error message
indicating that the reason for lookup failure perhaps is that
the setting is module-based and thus cannot be found in image
(extract-ikconfig's header comments don't fully document this fact either).
Will be creating a commit for this eventually (or do you want to add
such thing to your patchset now? ;).

Thanks for your effort,

Andreas Mohr
