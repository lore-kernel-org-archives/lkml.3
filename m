Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaKSNON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:14:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaKSNOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:14:11 -0500
Date: Wed, 19 Nov 2014 13:14:06 +0000
From: Mel Gorman <mgorman@suse.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
Message-ID: <20141119131406.GH2725@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de>
 <5466C8A5.3000402@oracle.com>
 <20141118154246.GB2725@suse.de>
 <546B74F5.10004@oracle.com>
 <87tx1w78hi.fsf@linux.vnet.ibm.com>
 <546B7F73.6090805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <546B7F73.6090805@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 12:18:43PM -0500, Sasha Levin wrote:
> On 11/18/2014 11:56 AM, Aneesh Kumar K.V wrote:
> >>> 4. Similarly, does the kernel boot properly without without patches?
> >> >
> >> > Yes, the kernel works fine without the patches both with and without fake
> >> > numa.
> > 
> > Hmm that is interesting. I am not sure how writeback_fid can be
> > related. We use writeback fid to enable client side caching with 9p
> > (cache=loose). We use this fid to write back dirty pages later. Can you
> > share the qemu command line used, 9p mount options and the test details ? 
> 
> I'm using kvmtool rather than qemu. rootfs is created via kernel parameters:
> 
> root=/dev/root rw rootflags=rw,trans=virtio,version=9p2000.L rootfstype=9p
> 
> The test is just running trinity, there's no 9p or mm specific test going on.
> 
> I've attached my .config.
> 

Ok, based on that I was able to reproduce the problem. I hope to have a
V2 before the end of the week. Thanks.

-- 
Mel Gorman
SUSE Labs
