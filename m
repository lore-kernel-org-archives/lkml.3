Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3GATxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:53:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3GATxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:53:47 -0400
Date: Mon, 1 Jul 2013 12:53:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Uvarov <muvarov@gmail.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>, riel@redhat.com,
        kexec@lists.infradead.org, hughd@google.com,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com, vgoyal@redhat.com,
        linux-mm@kvack.org, zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        kosaki.motohiro@jp.fujitsu.com, walken@google.com, cpw@sgi.com,
        jingbai.ma@hp.com
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
Message-Id: <20130701125345.c4a383c7b8345f9c5ae54023@linux-foundation.org>
In-Reply-To: <CAJGZr0Jwy6OLADBO9GExWVbwG_LMk41ZsSMZKvWmwcA9StVZQA@mail.gmail.com>
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6>
	<20130523052547.13864.83306.stgit@localhost6.localdomain6>
	<20130523152445.17549682ae45b5aab3f3cde0@linux-foundation.org>
	<CAJGZr0LwivLTH+E7WAR1B9_6B4e=jv04KgCUL_PdVpi9JjDpBw@mail.gmail.com>
	<51A2BBA7.50607@jp.fujitsu.com>
	<CAJGZr0LmsFXEgb3UXVb+rqo1aq5KJyNxyNAD+DG+3KnJm_ZncQ@mail.gmail.com>
	<51A71B49.3070003@cn.fujitsu.com>
	<CAJGZr0Ld6Q4a4f-VObAbvqCp=+fTFNEc6M-Fdnhh28GTcSm1=w@mail.gmail.com>
	<20130603174351.d04b2ac71d1bab0df242e0ba@mxc.nes.nec.co.jp>
	<CAJGZr0+9VUweN1Ssdq6P9Lug1GnTB3+RPv77JLRmnw=rpd9+Dw@mail.gmail.com>
	<51D0C500.4060108@jp.fujitsu.com>
	<CAJGZr0Jwy6OLADBO9GExWVbwG_LMk41ZsSMZKvWmwcA9StVZQA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013 18:34:43 +0400 Maxim Uvarov <muvarov@gmail.com> wrote:

> 2013/7/1 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> 
> > (2013/06/29 1:40), Maxim Uvarov wrote:
> >
> >> Did test on 1TB machine. Total vmcore capture and save took 143 minutes
> >> while vmcore size increased from 9Gb to 59Gb.
> >>
> >> Will do some debug for that.
> >>
> >> Maxim.
> >>
> >
> > Please show me your kdump configuration file and tell me what you did in
> > the test and how you confirmed the result.
> >
> >
> Hello Hatayama,
> 
> I re-run tests in dev env. I took your latest kernel patchset from
> patchwork for vmcore + devel branch of makedumpfile + fix to open and write
> to /dev/null. Run this test on 1Tb memory machine with memory used by some
> user space processes. crashkernel=384M.
> 
> Please see my results for makedumpfile process work:
> [gzip compression]
> -c -d31 /dev/null
> real 37.8 m
> user 29.51 m
> sys 7.12 m
> 
> [no compression]
> -d31 /dev/null
> real 27 m
> user 23 m
> sys   4 m
> 
> [no compression, disable cyclic mode]
> -d31 --non-cyclic /dev/null
> real 26.25 m
> user 23 m
> sys 3.13 m
> 
> [gzip compression]
> -c -d31 /dev/null
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  54.75   38.840351         110    352717           mmap
>  44.55   31.607620          90    352716         1 munmap
>   0.70    0.497668           0  25497667           brk
>   0.00    0.000356           0    111920           write
>   0.00    0.000280           0    111904           lseek
>   0.00    0.000025           4         7           open
>   0.00    0.000000           0       473           read
>   0.00    0.000000           0         7           close
>   0.00    0.000000           0         3           fstat
>   0.00    0.000000           0         1           getpid
>   0.00    0.000000           0         1           execve
>   0.00    0.000000           0         1           uname
>   0.00    0.000000           0         2           unlink
>   0.00    0.000000           0         1           arch_prctl
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   70.946300              26427420         1 total
> 

I have no point of comparison here.  Is this performance good, or is
the mmap-based approach still a lot more expensive?


