Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbaHYVWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:22:16 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45875 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaHYVWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:22:12 -0400
Date: Tue, 26 Aug 2014 01:22:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20140825212209.GQ25918@moon>
References: <20140823144246.GA6281@redhat.com>
 <20140825191207.GA26106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825191207.GA26106@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 09:12:07PM +0200, Oleg Nesterov wrote:
> +		vma = find_vma(current->mm, addr);
> +		if (vma) {
> +			unsigned long end = addr + size;
> +
> +			if (vma->vm_flags & VM_GROWSDOWN)
> +				end += PAGE_SIZE * 5;
> +
> +			if (end < addr || end > vma->vm_start)
> +				goto invalid;

Looks good to me, but I somehow missed in first version of the patch
too the following aspect -- end > vma->vm_start? Maybe end >= vma->vm_end?
