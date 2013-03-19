Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab3CSTaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:30:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab3CSTaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:30:07 -0400
Date: Tue, 19 Mar 2013 12:30:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
Message-Id: <20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 13:00:47 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> Currently, read to /proc/vmcore is done by read_oldmem() that uses
> ioremap/iounmap per a single page. For example, if memory is 1GB,
> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
> times. This causes big performance degradation.
> 
> In particular, the current main user of this mmap() is makedumpfile,
> which not only reads memory from /proc/vmcore but also does other
> processing like filtering, compression and IO work. Update of page
> table and the following TLB flush makes such processing much slow;
> though I have yet to make patch for makedumpfile and yet to confirm
> how it's improved.
> 
> To address the issue, this patch implements mmap() on /proc/vmcore to
> improve read performance. My simple benchmark shows the improvement
> from 200 [MiB/sec] to over 50.0 [GiB/sec].

There are quite a lot of userspace-visible vmcore changes here.  Is it
all fully back-compatible?  Will all known userspace continue to work
OK on newer kernels?

