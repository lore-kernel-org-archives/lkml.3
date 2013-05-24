Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3EXNM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab3EXNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:12:57 -0400
Date: Fri, 24 May 2013 09:12:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, ebiederm@xmission.com,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v8 3/9] vmcore: treat memory chunks referenced by PT_LOAD
 program header entries in page-size boundary in vmcore_list
Message-ID: <20130524131217.GA18218@redhat.com>
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6>
 <20130523052513.13864.85440.stgit@localhost6.localdomain6>
 <20130523144928.0328bb3ad7ccc1ff2da9558d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523144928.0328bb3ad7ccc1ff2da9558d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 02:49:28PM -0700, Andrew Morton wrote:
> On Thu, 23 May 2013 14:25:13 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
> 
> > Treat memory chunks referenced by PT_LOAD program header entries in
> > page-size boundary in vmcore_list. Formally, for each range [start,
> > end], we set up the corresponding vmcore object in vmcore_list to
> > [rounddown(start, PAGE_SIZE), roundup(end, PAGE_SIZE)].
> > 
> > This change affects layout of /proc/vmcore.
> 
> Well, changing a userspace interface is generally unacceptable because
> it can break existing userspace code.
> 
> If you think the risk is acceptable then please do explain why.  In
> great detail!

I think it should not be a problem as /proc/vmcore is useful only when
one parses the elf headers and then accesses the contents of file based
on the header information. This patch just introduces additional areas
in /proc/vmcore file and ELF headers still point to right contents. So
any tool parsing ELF headers and then accessing file contents based on
that info should still be fine.

AFAIK, no user space tool should be broken there.

Thanks
Vivek
