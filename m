Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3FGBOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:14:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab3FGBNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:13:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,818,1363104000"; 
   d="scan'208";a="7485802"
Message-ID: <51B1332E.4030907@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 09:11:10 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@gmail.com>
CC: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>, riel@redhat.com,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        hughd@google.com, linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>, walken@google.com,
        Cliff Wickman <cpw@sgi.com>, jingbai.ma@hp.com
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <20130523052547.13864.83306.stgit@localhost6.localdomain6> <20130523152445.17549682ae45b5aab3f3cde0@linux-foundation.org> <CAJGZr0LwivLTH+E7WAR1B9_6B4e=jv04KgCUL_PdVpi9JjDpBw@mail.gmail.com> <51A2BBA7.50607@jp.fujitsu.com> <CAJGZr0LmsFXEgb3UXVb+rqo1aq5KJyNxyNAD+DG+3KnJm_ZncQ@mail.gmail.com> <51A71B49.3070003@cn.fujitsu.com> <CAJGZr0Ld6Q4a4f-VObAbvqCp=+fTFNEc6M-Fdnhh28GTcSm1=w@mail.gmail.com> <20130603174351.d04b2ac71d1bab0df242e0ba@mxc.nes.nec.co.jp> <CAJGZr0KV9hmdFWQE5Z9kOieHSPhGKLAhsw1Me2RE2ADsbU=b7w@mail.gmail.com>
In-Reply-To: <CAJGZr0KV9hmdFWQE5Z9kOieHSPhGKLAhsw1Me2RE2ADsbU=b7w@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 09:12:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 09:12:07,
	Serialize complete at 2013/06/07 09:12:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:34 PM, Maxim Uvarov wrote:
> 
> 
> 
> 2013/6/3 Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp <mailto:kumagai-atsushi@mxc.nes.nec.co.jp>>
> 
>     Hello Maxim,
> 
>     On Thu, 30 May 2013 14:30:01 +0400
>     Maxim Uvarov <muvarov@gmail.com <mailto:muvarov@gmail.com>> wrote:
> 
>     > 2013/5/30 Zhang Yanfei <zhangyanfei@cn.fujitsu.com <mailto:zhangyanfei@cn.fujitsu.com>>
>     >
>     > > On 05/30/2013 05:14 PM, Maxim Uvarov wrote:
>     > > >
>     > > >
>     > > >
>     > > > 2013/5/27 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com> <mailto:
>     > > d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com>>>
>     > > >
>     > > >     (2013/05/24 18:02), Maxim Uvarov wrote:
>     > > >
>     > > >
>     > > >
>     > > >
>     > > >         2013/5/24 Andrew Morton <akpm@linux-foundation.org <mailto:akpm@linux-foundation.org> <mailto:
>     > > akpm@linux-foundation.org <mailto:akpm@linux-foundation.org>> <mailto:akpm@linux-foundation. <mailto:akpm@linux-foundation.>__org <mailto:
>     > > akpm@linux-foundation.org <mailto:akpm@linux-foundation.org>>>>
>     > > >
>     > > >
>     > > >             On Thu, 23 May 2013 14:25:48 +0900 HATAYAMA Daisuke <
>     > > d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com> <mailto:d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com>> <mailto:
>     > > d.hatayama@jp.fujitsu.__com <mailto:d.hatayama@jp.fujitsu.com <mailto:d.hatayama@jp.fujitsu.com>>>> wrote:
>     > > >
>     > > >              > This patch introduces mmap_vmcore().
>     > > >              >
>     > > >              > Don't permit writable nor executable mapping even with
>     > > mprotect()
>     > > >              > because this mmap() is aimed at reading crash dump memory.
>     > > >              > Non-writable mapping is also requirement of
>     > > remap_pfn_range() when
>     > > >              > mapping linear pages on non-consecutive physical pages;
>     > > see
>     > > >              > is_cow_mapping().
>     > > >              >
>     > > >              > Set VM_MIXEDMAP flag to remap memory by remap_pfn_range
>     > > and by
>     > > >              > remap_vmalloc_range_pertial at the same time for a single
>     > > >              > vma. do_munmap() can correctly clean partially remapped
>     > > vma with two
>     > > >              > functions in abnormal case. See zap_pte_range(),
>     > > vm_normal_page() and
>     > > >              > their comments for details.
>     > > >              >
>     > > >              > On x86-32 PAE kernels, mmap() supports at most 16TB
>     > > memory only. This
>     > > >              > limitation comes from the fact that the third argument of
>     > > >              > remap_pfn_range(), pfn, is of 32-bit length on x86-32:
>     > > unsigned long.
>     > > >
>     > > >             More reviewing and testing, please.
>     > > >
>     > > >
>     > > >         Do you have git pull for both kernel and userland changes? I
>     > > would like to do some more testing on my machines.
>     > > >
>     > > >         Maxim.
>     > > >
>     > > >
>     > > >     Thanks! That's very helpful.
>     > > >
>     > > >     --
>     > > >     Thanks.
>     > > >     HATAYAMA, Daisuke
>     > > >
>     > > > Any update for this? Where can I checkout all sources?
>     > >
>     > > This series is now in Andrew Morton's -mm tree.
>     > >
>     > > Ok, and what about makedumpfile changes? Is it possible to fetch them from
>     > somewhere?
> 
>     You can fetch them from here, "mmap" branch is the change:
> 
>       git://git.code.sf.net/p/makedumpfile/code <http://git.code.sf.net/p/makedumpfile/code>
> 
>     And they will be merged into v1.5.4.
> 
> 
> thank you, got it. But still do not see kernel patches in akpm tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> 
> Should I look at different branch?

Now it is merged into the next tree you list above. See the commit:

author	HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>	2013-06-06 00:40:01 (GMT)
committer	Stephen Rothwell <sfr@canb.auug.org.au>	2013-06-06 05:50:03 (GMT)
commit	4be2c06c30e4c3994d86e0be24ff1af12d2c71d5 (patch)
tree	d7fb8c64c628600e8ba24481927f087fc11c2986
parent	99f80952861807e521ed30c22925f009f543a5ec (diff)

-- 
Thanks.
Zhang Yanfei
