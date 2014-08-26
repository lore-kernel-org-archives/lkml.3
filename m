Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaHZTjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbaHZTjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:39:54 -0400
Date: Tue, 26 Aug 2014 21:37:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipc/shm: fix the historical/wrong mm->start_stack
	check
Message-ID: <20140826193709.GB26576@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140825191207.GA26106@redhat.com> <20140825212209.GQ25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825212209.GQ25918@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Cyrill Gorcunov wrote:
>
> On Mon, Aug 25, 2014 at 09:12:07PM +0200, Oleg Nesterov wrote:
> > +		vma = find_vma(current->mm, addr);
> > +		if (vma) {
> > +			unsigned long end = addr + size;
> > +
> > +			if (vma->vm_flags & VM_GROWSDOWN)
> > +				end += PAGE_SIZE * 5;
> > +
> > +			if (end < addr || end > vma->vm_start)
> > +				goto invalid;
>
> Looks good to me, but I somehow missed in first version of the patch
> too the following aspect -- end > vma->vm_start? Maybe end >= vma->vm_end?

I think ">" is correct, the last byte is "addr + size - 1". Otherwise,
say, find_vma_intersection() is buggy. But this doesn't matter, please
see v3.

Oleg.

