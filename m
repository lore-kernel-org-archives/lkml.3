Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3CKIb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:31:29 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28657 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKIb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:31:28 -0400
Message-ID: <513D965B.8010503@hp.com>
Date: Mon, 11 Mar 2013 16:31:23 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Ma, Jingbai (Kingboard)" <kingboard.ma@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        jingbai.ma@hp.com
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
References: <CD6006EB.36EC%kingboard.ma@hp.com> <87r4jpoono.fsf@xmission.com>
In-Reply-To: <87r4jpoono.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 12:13 AM, Eric W. Biederman wrote:
> "Ma, Jingbai (Kingboard)"<kingboard.ma@hp.com>  writes:
>
>> On 3/8/13 6:33 PM, "H. Peter Anvin"<hpa@zytor.com>  wrote:
>>
>>
>>> On 03/08/2013 02:06 AM, Jingbai Ma wrote:
>>>>
>>>> Kernel do have some abilities that user space haven't. It's possible to
>>>> map whole memory space of the first kernel into user space on the second
>>>> kernel. But the user space code has to re-implement some parts of the
>>>> kernel memory management system again. And worse, it's architecture
>>>> dependent, more architectures supported, more codes have to be
>>>> implemented. All implementation in user space must be sync to kernel
>>>> implementation. It's may called "flexibility", but it's painful to
>>>> maintain the codes.
>>>>
>>>
>>> What?  You are basically talking about /dev/mem... there is nothing
>>> particularly magic about it at all.
>>
>> What we are talking about is filtering memory pages (AKA memory pages
>> classification)
>> The makedumpfile (or any other dumper in user space) has to know the
>> exactly
>> memory layout of the memory management data structures, it not only
>> architecture dependent, but also may varies in different kernel release.
>> At this point, /dev/mem doesn't give any help.
>> So IMHO, I would like to do it in kernel, rather than So keep tracking
>> changes in user space code.
>
> But the fact is there is no requirment that the crash dump capture
> kernel is the same version as the kernel that crashed.  In fact it has
> been common at some points in time to use slightly different build
> options, or slightly different kernels.  Say a 32bit PAE kernel to
> capture a 64bit x86_64 kernel.

The filtering code will be executed in the first kernel, so this problem 
will not be exist.

>
> So in fact performing this work in the kernel and is actively harmful to
> reliability and maintenance because it adds an incorrect assumption.
>
> If you do want the benefit of shared maintenance with the kernel one
> solution that has been suggested several times is to put code into
> tools/makedumpfile (probably a library) that encapsulates the kernel
> specific knowledge that can be loaded into the ramdisk when the
> crahsdump kernel is being loaded.
>
> That would allow shared maintenance along without breaking the
> possibility of supporting kernel versions.

Yes, you are right. But it requires makedumpfile changes significantly, 
and if we also want to shared the code with kernel memory management 
subsystem, I believe that's not a easy job. (at least to my limited 
kernel knowledge)

>
> Eric


-- 
Jingbai Ma (jingbai.ma@hp.com)
