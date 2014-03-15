Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaCOSN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 14:13:28 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:39700 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaCOSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 14:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140224114725.GA31065@spaans-e6500>
References: <20140224114725.GA31065@spaans-e6500>
Date: Sat, 15 Mar 2014 11:13:26 -0700
X-Google-Sender-Auth: QJihm6B7eOMQh3SJc5MThp-Fcsk
Message-ID: <CA+55aFwC4i2_Rf-bFqpyA6q1XL6KFdvPqFALavB8WoaXGgm_dg@mail.gmail.com>
Subject: Re: kernel panic 3.11.7 in kmem_cache_alloc+0x66/0x150
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jasper Spaans <spaans@fox-it.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Going through old emails, this is probably stale by now since you
already figured out it was fixed in 3.13 ]

On Mon, Feb 24, 2014 at 3:47 AM, Jasper Spaans <spaans@fox-it.com> wrote:
>
> Last weekend one of our machines showed some interesting behaviour, where
> processes seemed to be crashing randomly. Further inspection showed that
> all the oopses in syslog were on core #12, and had
> kmem_cache_alloc+0x66/0x150 as the RIP, except for the second one, which had
> kmem_cache_alloc_trace+0x6a/0x140 .

This indeed looks very much like the pipe use-after-free that was
fixed by commit b0d8d2292160 ("vfs: fix subtle use-after-free of
pipe_inode_info"), and afffects 3.10-3.12. It should be in stable
kernels, but you probably have a 3.11 that predates that stable
backport.

For 3.11, you need 3.11.10.2 or newer, but 3.12 or 3.13 stable sounds
like a better idea from a maintenance standpoint.

            Linus
