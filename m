Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3CVAnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:43:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52605 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3CVAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:43:40 -0400
Date: Fri, 22 Mar 2013 09:43:32 +0900 (JST)
Message-Id: <20130322.094332.87614031.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130321152751.GK3934@redhat.com>
References: <87a9pxz0wv.fsf@xmission.com>
	<20130321152124.GJ3934@redhat.com>
	<20130321152751.GK3934@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
Date: Thu, 21 Mar 2013 11:27:51 -0400

> On Thu, Mar 21, 2013 at 11:21:24AM -0400, Vivek Goyal wrote:
> 
> [..]
>> So if starting or end address of PT_LOAD header is not aligned, why
>> not we simply allocate a page. Copy the relevant data from old memory,
>> fill rest with zero. That way mmap and read view will be same. There
>> will be no surprises w.r.t reading old kernel memory beyond what's 
>> specified by the headers.
> 
> Copying from old memory might spring surprises w.r.t hw poisoned
> pages. I guess we will have to disable MCE, read page, enable it
> back or something like that to take care of these issues.
> 
> In the past we have recommended makedumpfile to be careful, look
> at struct pages and make sure we are not reading poisoned pages.
> But vmcore itself is reading old memory and can run into this
> issue too.

Yes, that has been already implemented in makedumpfile.

Not only copying, but also mmaping poisoned pages might be problematic
due to hardware cache prefetch performed by creation of page table to
the poisoned pages. Or MCE disables the prefetch? I'm not sure but
I'll investigate this. makedumpfile might also take care of calling
mmap.

Thanks.
HATAYAMA, Daisuke

