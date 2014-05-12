Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbaELOBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:01:46 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:56641
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbaELOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:01:45 -0400
Date: Mon, 12 May 2014 09:01:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        mgorman@suse.de, zhangyanfei@cn.fujitsu.com, aarcange@redhat.com,
        fabf@skynet.be, sasha.levin@oracle.com, oleg@redhat.com,
        n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, gorcunov@gmail.com,
        dave.hansen@linux.intel.com, toshi.kani@hp.com,
        paul.gortmaker@windriver.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
In-Reply-To: <1399811500-14472-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1405120858040.3090@gentwo.org>
References: <1399811500-14472-1-git-send-email-nasa4836@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2014, Jianyu Zhan wrote:

> >
> >/*
> > * For use when we know that interrupts are disabled,
> > * or when we know that preemption is disabled and that
> > * particular counter cannot be updated from interrupt context.
> > */
>
>  Seconded. Christoph, would you please write a comment? I've written
>  a new one based on Hugh's, would you please also take a look? Thanks.

The description above looks ok to me. The problem is that you are
considering the page related data structures as an issue for races and not
the data structures relevant for vm statistics.

> It is essential to have such gurantees, because __mod_zone_page_stat()
> is a two-step operation : read-percpu-couter-then-modify-it.
> (Need comments. Christoph, do I misunderstand it?)

Yup.

> mlocked_vma_newpage() is only called in fault path by
> page_add_new_anon_rmap(), which is called on a *new* page.
> And such page is initially only visible via the pagetables, and the
> pte is locked while calling page_add_new_anon_rmap(), so we need not
> use an irq-safe mod_zone_page_state() here, using a light-weight version
> __mod_zone_page_state() would be OK.

This is wrong.. What you could say is that preemption is off and that the
counter is never incremented from an interrupt context that could race
with it. If this is the case then it would be safe.
