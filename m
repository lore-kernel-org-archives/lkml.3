Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3BJV7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 16:59:13 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38529 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab3BJV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 16:59:11 -0500
MIME-Version: 1.0
In-Reply-To: <5117F5D5.8040709@chronox.de>
References: <51157686.9000404@chronox.de>
	<20130209180629.GD8091@thunk.org>
	<20130210015751.GA13690@unpythonic.net>
	<5117969A.1080909@chronox.de>
	<20130210185002.GA10801@thunk.org>
	<5117F5D5.8040709@chronox.de>
Date: Sun, 10 Feb 2013 16:59:10 -0500
Message-ID: <CACXcFmkmENTrGcchiWVpEe+U5arq798Ys+ef1t70y2uQqz6YDQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jeff Epler <jepler@unpythonic.net>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 2:32 PM, Stephan Mueller <smueller@chronox.de> wrote:

> On 10.02.2013 19:50:02, +0100, Theodore Ts'o <tytso@mit.edu> wrote:

> Given all your doubts on the high-precision timer, how can you
> reasonably state that the Linux kernel RNG is good then?
>
> The data from add_timer_randomness the kernel feeds into the input_pool
> is a concatenation of the event value, the jiffies and the get_cycles()
> value. The events hardly contains any entropy, the jiffies a little bit
> due to the coarse resolution of 250 or 1000 Hz. Only the processor
> cycles value provides real entropy.

There are multiple sources of entropy, though. There are reasons
not to fully trust any -- key strike statistics can be predicted if the
enemy knows the language, the enemy might be monitoring the
network. there is no keyboard or mouse on a headless server, a
diskless machine has no disk timing entropy and one with an
SSD or intelligent RAID controller very little, .... However, with
multiple sources and conservative estimates, it is reasonable
to hope there is enough entropy coming in somewhere.

It is much harder to trust a system with single source of
entropy, perhaps impossible for something that is likely to
be deployed on the whole range of things Linux runs on,
from a cell phone with a single 32-bit CPU all the way to
beowulf-based supercomputers with thousands of
multicore chips.

Moeove, random(4) has both a large entropy pool (or
three, to be more precise) and strong crypto in the
mixing. If it /ever/ gets a few hundred bits of real
entropy then no-one without the resources of a
major government and/or a brilliant unpublished
attack on SHA-1 can even hope to break it.

In the default Linux setup, it gets few K bits of
reasonably good entropy from the initialisation
scripts, so attacks look impossible unless the
enemy already has root privileges or has
physical access to boot the machine from
other media & look at Linux storage.
