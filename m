Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab3DZC3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 22:29:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab3DZC3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 22:29:14 -0400
Message-ID: <5179E652.808@zytor.com>
Date: Thu, 25 Apr 2013 19:28:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
References: <51559150.3040407@oracle.com> <20130410080202.GB21292@blaptop> <517861E0.7030801@zytor.com> <51786D52.1080509@gmail.com>
In-Reply-To: <51786D52.1080509@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 04:40 PM, Simon Jeons wrote:
> 
> I see in memblock_trim_memory(): start = round_up(orig_start, align);
> here align is PAGE_SIZE, so the dump of zone ranges in my machine is [ 
>   0.000000]  DMA      [mem 0x00001000-0x00ffffff]. Why PFN 0 is not
> used? just for align?
> 

PFN 0 contains the real-mode interrupt vector table and BIOS data area,
so we just reserve it.  Avoids issues with zero being special, too.

	-hpa


