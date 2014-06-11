Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaFKUyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:54:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaFKUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:54:15 -0400
Date: Wed, 11 Jun 2014 13:54:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Anderson <dianders@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>
Subject: Re: CONFIG_PREMPT vs. linux-next causes slub_debug=FZPUA errors
Message-Id: <20140611135413.ecd77d52dcf1d4fd6671ac8c@linux-foundation.org>
In-Reply-To: <CAD=FV=VX6QqL+jdEwk8Mp53FHBqj2v=w65zqBcbYWTtPZPmMVQ@mail.gmail.com>
References: <CAD=FV=VX6QqL+jdEwk8Mp53FHBqj2v=w65zqBcbYWTtPZPmMVQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 15:38:00 -0700 Doug Anderson <dianders@chromium.org> wrote:

> Hi,
> 
> Recently, both Andrew Bresticker (CCed) and I have noticed errors
> reported by slub_debug when using linuxnext.  I'm still seeing them on
> 20140606.
> 
> 
> NOTES:
> * errors only seem to be present when you've got CONFIG_PREMPT enabled.
> 
> * errors seem to happen most often when rebooting, but I've seen them
> during other times as well.
> 
> * a quick guesstimate is that ~50% of my reboots show this problem.
> 
> * I'm testing on an exynos5250-based board and Andrew on an ARM board
> with a different SoC.
> 
> * I don't see issues on a current fetch of "linux", AKA (5b174fd Merge
> branch 'for-3.16' of git://linux-nfs.org/~bfields/linux)
> 
> 
> I didn't do a full bisect, but I don't seem to see issues on 20140528.
> On 20140530 I see almost constant slub errors (seems much worse than
> 20140606)
> 
> An example error is below:
> 
> 
> [   13.521842] =============================================================================
> [   13.528566] BUG bio-1 (Not tainted): Poison overwritten
> [   13.533765] -----------------------------------------------------------------------------
> [   13.533765]
> [   13.543394] Disabling lock debugging due to kernel taint
> [   13.548685] INFO: 0xec495848-0xec49584f. First byte 0x80 instead of 0x6b
> [   13.555378] INFO: Allocated in mempool_alloc_slab+0x24/0x28 age=28
> cpu=5 pid=220
> [   13.562741]  kmem_cache_alloc+0x90/0x1d0
> [   13.566640]  mempool_alloc_slab+0x24/0x28
> [   13.570631]  mempool_alloc+0x4c/0x144
> [   13.574279]  bio_alloc_bioset+0xa4/0x1b0
> [   13.578182]  __split_and_process_bio+0x33c/0x3f0
> [   13.582778]  dm_request+0x1f0/0x204
> [   13.586248]  generic_make_request+0xa4/0xdc
> [   13.590411]  submit_bio+0x114/0x144

This one is possibly a bug in DM or the BIO layer.

Do you have more examples?  I couldn't locate a report from Andrew.
