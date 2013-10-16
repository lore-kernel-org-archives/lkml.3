Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab3JPQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab3JPQQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:16:55 -0400
Date: Wed, 16 Oct 2013 18:09:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup
	xol_area
Message-ID: <20131016160939.GA13405@redhat.com>
References: <20131013191815.GA32466@redhat.com> <20131013191844.GA32502@redhat.com> <20131016125327.GI19729@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016125327.GI19729@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:44]:
>
> > We know that this vaddr is fine for install_special_mapping(), the
> > necessary hole was recently "created" by dup_mmap() which skips the
> > parent's VM_DONTCOPY area, and nobody else could use the new mm.
>
>
> I was actually thinking if we can remove the VM_DONTCOPY from
> install_special_mapping,

I considered this option. I even thought about playing with vm_flags
in uprobe_start/stop_dup_mmap ;)

> But there are obvious issues with that approach

and we simply can't do this. Unlike, say, vdso xol vma can not be
cloned automatically, we obviously can't use the same area->page.
Plus we need to dup area itself, at least for ->bitmap.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

Oleg.

