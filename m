Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3GOOWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab3GOOWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:22:03 -0400
Date: Mon, 15 Jul 2013 10:20:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130715142059.GA23772@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
 <51DA4ED9.60903@jp.fujitsu.com>
 <20130708112839.498ccfc6@holzheu>
 <20130708142826.GA9094@redhat.com>
 <51DBA47C.8090708@jp.fujitsu.com>
 <20130710104252.479a0f92@holzheu>
 <51DD2E5A.1030200@jp.fujitsu.com>
 <20130710143309.GD5819@redhat.com>
 <51DFE2FB.2000804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DFE2FB.2000804@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 08:05:31PM +0900, HATAYAMA Daisuke wrote:

[..]
> How about
> 
> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
> ...
>         char *buf;
>         int rc;
> 
> #ifndef CONFIG_S390
>         return VM_FAULT_SIGBUS;
> #endif
>         page = find_or_create_page(mapping, index, GFP_KERNEL);
> 
> Considering again, I don't think WARN_ONCE() is good now. The fact that fault occurs on
> mmap() region indicates some kind of buggy situation occurs on the process. The process
> should be killed as soon as possible. If user still wants to get crash dump, he should
> try again in another process.

I don't understand that. Process should be killed only if there was no
mapping created for the region process is trying to access.

If there is a mapping but we are trying to fault in the actual contents,
then it is not a problem of process. Process is accessing a region of 
memory which it is supposed to access.

Potential problem here is that remap_pfn_range() did not map everything
it was expected to so we have to resort on page fault handler to read
that in. So it is more of a kernel issue and not process issue and for
that WARN_ONCE() sounds better?

Vivek
