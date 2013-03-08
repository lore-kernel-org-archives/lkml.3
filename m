Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3CHBbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:31:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59513 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3CHBba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:31:30 -0500
Date: Fri, 08 Mar 2013 10:31:22 +0900 (JST)
Message-Id: <20130308.103122.225284544.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: jingbai.ma@hp.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, hpa@zytor.com, yinghai@kernel.org
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130307152108.GC2790@redhat.com>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
	<20130307152108.GC2790@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
Date: Thu, 7 Mar 2013 10:21:08 -0500

> On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
<cut>
>> 
>> 2. Scans all memory pages in makedumpfile is a very slow process. On
>> system with 1TB or more memory installed, the scanning process is very
>> long. Typically on 1TB idle system, it takes about 19 minutes. On system
>> with 4TB or more memory installed, it even doesn't work. To address the
>> out of memory issue on system with big memory (4TB or more memory
>> installed),  makedumpfile v1.5.1 introduces a new cyclic mode. It only
>> scans a piece of memory pages each time, and do it cyclically to scan
>> all memory pages. But it runs more slowly, on 1TB system, takes about 33
>> minutes.
> 
> One of the reasons it is slow because we don't support mmpa() interface.
> That means for every read, we map 4K page, flush TLB, read it, unmap it
> and flush TLB again. This is lot of processing overhead per 4K page.
> 
> Hatayama is now working on making mmap() interface and allow user space
> to bigger chunks of memory in one so. So that in one mmap() call we can
> map a bigger range instead of just 4K. And his numbers show that it
> has helped a lot.

Yes, so when are you able to get down to reviewing the patch set?

Thanks.
HATAYAMA, Daisuke

