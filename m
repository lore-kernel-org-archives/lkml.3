Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaDARYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:24:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34094 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaDARYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:24:01 -0400
Message-ID: <533AF612.8020505@zytor.com>
Date: Tue, 01 Apr 2014 10:23:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platforms for v3.15
References: <20140401082757.GA23451@gmail.com> <CA+55aFzKCVnqYussDpt8Fkoi28SthKRd3oKnSW4GnED+s6QdVQ@mail.gmail.com>
In-Reply-To: <CA+55aFzKCVnqYussDpt8Fkoi28SthKRd3oKnSW4GnED+s6QdVQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This one is largely my fault, but it is not for not asking the questions.

This patch is part of the work of modularizing the IOSF drivers, because
of course standard distros don't want to compile them in.  However, this
results in odd problems when IOSF-aware drivers (some of which are
present on non-IOSF hardware, as there are drivers that operate on both
PCI and IOSF, some of which are still coming down the pipe toward mainline.)

It is these dual-mode drivers that make things a bit more complicated
than it ought to be.

I have explicitly asked David to work on modularizing the IOSF core,
even though it is small, exactly to avoid this mess.  However, that
change didn't make it in time, and I guess I should just have said "no"
at that point.

I did not want to not have an option to disable it for EXPERT
configurations, because we also have people working very hard at shaving
down the size of the x86 kernel so that Linux rather than "random RTOS
of the month" can be used in deep embedded configurations.

On this issue:

>  (a) people don't know about, so asking people about it is f*cking
> retarded to begin with

Well, that is why it is an EXPERT option.

+	bool "IOSF MBI support" if EXPERT

	-hpa
