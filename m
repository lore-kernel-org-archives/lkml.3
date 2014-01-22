Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaAVQn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:43:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaAVQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:43:27 -0500
Date: Wed, 22 Jan 2014 11:43:11 -0500
From: Dave Jones <davej@redhat.com>
To: jack@suse.cz, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fanotify use after free.
Message-ID: <20140122164311.GA26523@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, jack@suse.cz,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20140122062730.GA25601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122062730.GA25601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 01:27:30AM -0500, Dave Jones wrote:
 > Jan,
 > 
 > since yesterdays changes, on boot I see a flood of messages from slub debug during boot..
 > 
 > =============================================================================
 > BUG fanotify_event_info (Not tainted): Poison overwritten
 > -----------------------------------------------------------------------------
 > 
 > Disabling lock debugging due to kernel taint
 > INFO: 0xffff880247e45bc8-0xffff880247e45bcb. First byte 0x0 instead of 0x6b
 > INFO: Allocated in fanotify_handle_event+0x136/0x390 age=0 cpu=0 pid=293
 >  __slab_alloc+0x456/0x565
 >  kmem_cache_alloc+0x1fe/0x260
 >  fanotify_handle_event+0x136/0x390
 >  send_to_group+0xd3/0x1c0
 >  fsnotify+0x1c8/0x340
 >  open_exec+0xe2/0x120
 >  load_elf_binary+0x7b7/0x18e0
 >  search_binary_handler+0x94/0x1b0
 >  do_execve_common.isra.26+0x5d7/0x7d0
 >  SyS_execve+0x36/0x50
 >  stub_execve+0x69/0xa0
 > INFO: Freed in fanotify_free_event+0x2e/0x40 age=0 cpu=3 pid=290
 >  __slab_free+0x4a/0x382
 >  kmem_cache_free+0x1c9/0x210
 >  fanotify_free_event+0x2e/0x40
 >  fsnotify_destroy_event+0x21/0x30
 >  fanotify_read+0x39e/0x5e0
 >  vfs_read+0x9b/0x160
 >  SyS_read+0x58/0xb0
 >  tracesys+0xdd/0xe2
 > INFO: Slab 0xffffea00091f9100 objects=20 used=20 fp=0x          (null) flags=0x20000000004080

Reverting 7053aee26a3548ebaba046ae2e52396ccf56ac6c makes this go away.

	Dave

