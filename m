Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaAGKJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:09:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaAGKJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:09:15 -0500
Message-ID: <52CBD247.8080508@suse.cz>
Date: Tue, 07 Jan 2014 11:09:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Josh Triplett <josh@joshtriplett.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
References: <20140106204706.GA16924@leaf>	<20140107055532.GA16581@ravnborg.org> <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-07 10:48, Geert Uytterhoeven wrote:
> Furthermore some userspace may rely on doing #define XXX to avoid
> including a specific kernel header (yes, it's ugly).

This pattern is also sometimes used:
$ head -6 include/linux/spinlock_up.h
#ifndef __LINUX_SPINLOCK_UP_H
#define __LINUX_SPINLOCK_UP_H

#ifndef __LINUX_SPINLOCK_H
# error "please don't include this file directly"
#endif

And there is nothing ugly about it. So #pragma once is probably a good
idea for most headers that are not exposed to userspace. But making it a
requirement in scripts/checkpatch.pl or Documentation/CodingStyle means
that it will become hard to defend the few legitimate uses of ifndef
guards against people who have a printed copy of checkpatch.pl under
their pillow.

Michal
