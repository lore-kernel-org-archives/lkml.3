Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3CVCbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:31:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39394 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3CVCbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:31:49 -0400
Date: Fri, 22 Mar 2013 11:30:29 +0900 (JST)
Message-Id: <20130322.113029.44701859.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87ip4kntj5.fsf@xmission.com>
References: <20130321152124.GJ3934@redhat.com>
	<20130321152751.GK3934@redhat.com>
	<87ip4kntj5.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
Date: Thu, 21 Mar 2013 17:54:22 -0700

> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> On Thu, Mar 21, 2013 at 11:21:24AM -0400, Vivek Goyal wrote:
>>
>> [..]
>>> So if starting or end address of PT_LOAD header is not aligned, why
>>> not we simply allocate a page. Copy the relevant data from old memory,
>>> fill rest with zero. That way mmap and read view will be same. There
>>> will be no surprises w.r.t reading old kernel memory beyond what's 
>>> specified by the headers.
>>
>> Copying from old memory might spring surprises w.r.t hw poisoned
>> pages. I guess we will have to disable MCE, read page, enable it
>> back or something like that to take care of these issues.
>>
>> In the past we have recommended makedumpfile to be careful, look
>> at struct pages and make sure we are not reading poisoned pages.
>> But vmcore itself is reading old memory and can run into this
>> issue too.
> 
> Vivek you are overthinking this.
> 
> If there are issues with reading partially exported pages we should
> fix them in kexec-tools or in the kernel where the data is exported.
> 
> In the examples given in the patch what we were looking at were cases
> where the BIOS rightly or wrongly was saying kernel this is my memory
> stay off.  But it was all perfectly healthy memory.
> 
> /proc/vmcore is a simple data dumper and prettifier.  Let's keep it that
> way so that we can predict how it will act when we feed it information.
> /proc/vmcore should not be worrying about or covering up sins elsewhere
> in the system.
> 
> At the level of /proc/vmcore we may want to do something about ensuring
> MCE's don't kill us.  But that is an orthogonal problem.

This is the part of old memory /proc/vmcore must read at its
initialization to generate its meta data, i.e. ELF header, program
header table and ELF note segments. Other memory chunks are part
makedumpfile should decide whether to read or avoid.

Thanks.
HATAYAMA, Daisuke

