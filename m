Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3KUQxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:53:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3KUQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:53:07 -0500
Date: Thu, 21 Nov 2013 11:52:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Message-ID: <20131121165237.GG16208@redhat.com>
References: <5284A689.70903@jp.fujitsu.com>
 <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com>
 <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <20131118135511.GA30637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
 <20131120145901.GB27924@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C43E3@BPXM01GP.gisp.nec.co.jp>
 <528DC4F2.5040000@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528DC4F2.5040000@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:31:46PM +0900, HATAYAMA Daisuke wrote:

[..]
> > So I think the patch I sent is enough, the policy will be simpler as
> > "Don't use mmap() for buggy kernels".
> > 
> > [PATCH] Fall back to read() when mmap() fails.
> > http://lists.infradead.org/pipermail/kexec/2013-November/010199.html
> > 
> 
> I think logic becomes not so complex. For example, if input vmcore
> format is ELF, then:
> 
> o in update_mmap_range():
>   - first calculate a range of the corresponding PT_LOAD entry truncated with
>     PAGE_SIZE.
>   - Then, truncate range of mmap() by the truncated range of the corresponding
>     PT_LOAD entry, i.e., exlucde partial pages from mmap() target range.
>   - Then determine offsets of two partial pages; the number of partial pages
>     are always at most two. The offsets can easily be calculated from the
>     original range of the corresponding PT_LOAD entry
> 
> o in read_from_vmcore(), if a given offset belongs to either of two partial
>   pages, then go to read() path; if not, go to mmap() path.

I agree that we should do mmap() on all non-partial pages and do read()
on all partial pages. Otherwise we lose the benefit of faster speed of
mmap().

Thanks
Vivek
