Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3GJOeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3GJOeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:34:06 -0400
Date: Wed, 10 Jul 2013 10:33:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130710143309.GD5819@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
 <51DA4ED9.60903@jp.fujitsu.com>
 <20130708112839.498ccfc6@holzheu>
 <20130708142826.GA9094@redhat.com>
 <51DBA47C.8090708@jp.fujitsu.com>
 <20130710104252.479a0f92@holzheu>
 <51DD2E5A.1030200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DD2E5A.1030200@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 06:50:18PM +0900, HATAYAMA Daisuke wrote:

[..]
> If you want to avoid looking up vmcore_list that takes linear time w.r.t. the number
> of the elements, you can still calculate the range of offsets in /proc/vmcore
> corresponding to HSA during /proc/vmcore initialization.
> 
> Also, could you tell me how often and how much the HSA region is during crash dumping?
> I guess the read to HSA is done mainly during early part of crash dumping process only.
> According to the code, it appears at most 64MiB only. Then, I feel performance is not
> a big issue.
> 
> Also, cost of WARN_ONCE() is one memory access only in the 2nd and later calls. I don't
> think it too much overhead...

Hi Hatayama,

I think michael's proposal of just putting in WARN_ONCE for non s390 arch
sounds reasonable. It is simple and meets your need of being able to 
detect that non s390 arch don't make use of mmap() path yet. Introducing
in_valid_fault_range() kind of sounds overkill to me for this issue.

Thanks
Vivek
