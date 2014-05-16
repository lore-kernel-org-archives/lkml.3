Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaEPPb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbaEPPby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:31:54 -0400
Date: Fri, 16 May 2014 17:30:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: uprobes && shmem (Was: uprobes: Shift ->readpage check from
	__copy_insn() to uprobe_register())
Message-ID: <20140516153058.GA30667@redhat.com>
References: <20140516152919.GA30659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516152919.GA30659@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 05/16, Oleg Nesterov wrote:
>
> copy_insn() fails with -EIO if ->readpage == NULL

In particular, this means that we can not probe the binaries on tmpfs.
This is pity.

It seems that the potential fix is trivial, copy_insn() could use
shmem_getpage_gfp(). But, is there any way to figure out that this
inode/mapping/aops/whatever is actually shmem?

I am looking at shmem_get_inode() and I see nothing which could help,
and shmem_aops/etc are all static.

Oleg.

