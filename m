Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3CUDw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:52:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33085 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CUDw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:52:56 -0400
Date: Thu, 21 Mar 2013 12:52:45 +0900 (JST)
Message-Id: <20130321.125245.142520187.d.hatayama@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
Date: Tue, 19 Mar 2013 12:30:05 -0700

> On Sat, 16 Mar 2013 13:00:47 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
> 
>> Currently, read to /proc/vmcore is done by read_oldmem() that uses
>> ioremap/iounmap per a single page. For example, if memory is 1GB,
>> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
>> times. This causes big performance degradation.
>> 
>> In particular, the current main user of this mmap() is makedumpfile,
>> which not only reads memory from /proc/vmcore but also does other
>> processing like filtering, compression and IO work. Update of page
>> table and the following TLB flush makes such processing much slow;
>> though I have yet to make patch for makedumpfile and yet to confirm
>> how it's improved.
>> 
>> To address the issue, this patch implements mmap() on /proc/vmcore to
>> improve read performance. My simple benchmark shows the improvement
>> from 200 [MiB/sec] to over 50.0 [GiB/sec].
> 
> There are quite a lot of userspace-visible vmcore changes here.  Is it
> all fully back-compatible?  Will all known userspace continue to work
> OK on newer kernels?
> 

I designed it to keep backward-compatibility at least for gdb and
binutils but not less for makedumpfile since it should follow kernel
changes; old makedumpfile cannot use newer kernels, and this is within
the range of this review.

Thanks.
HATAYAMA, Daisuke

