Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3GPPzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:55:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360Ab3GPPzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:55:31 -0400
Date: Tue, 16 Jul 2013 11:55:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130716155459.GB3398@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130702154214.GC22603@redhat.com>
 <20130715154451.02a3a767@holzheu>
 <20130715142708.GB23772@redhat.com>
 <20130716112527.35decf17@holzheu>
 <20130716140418.GB4005@redhat.com>
 <20130716173709.3fed4c42@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716173709.3fed4c42@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 05:37:09PM +0200, Michael Holzheu wrote:

[..]
> The problem is that with the mmap patches we now use copy_oldmem_page()
> to copy the notes from oldmem into the notes_buf which has been allocated
> with vmalloc. The s390 version of copy_oldmem_page() bypasses the page
> tables and uses real copy. And this does not work on vmalloc memory.

I got that. I am trying to remember that in 3.10 why are we dropping
to real mode in s390 while copying pages.

I thought dropping to real mode was needed only to access HSA region.
HSA region comes into the picture only for zfcudump and /proc/vmcore support
for zfcpdump is not there yet

IOW, what if we start copying with page tables enabled in s390. Will
it not work for regular kdump case and take care of zfcpdump in 3.12.

Thanks
Vivek
