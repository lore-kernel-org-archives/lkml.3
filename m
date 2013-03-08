Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3CHNCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:02:53 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46711 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3CHNCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:02:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130308.105519.82764856.d.hatayama@jp.fujitsu.com>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083714.31252.17863.stgit@localhost6.localdomain6>
	<513867D2.7090501@cn.fujitsu.com>
	<20130308.105519.82764856.d.hatayama@jp.fujitsu.com>
Date: Fri, 8 Mar 2013 21:02:50 +0800
Message-ID: <CANBD6kFwTjKL9CqUzVSWFSRH6ibdQstCU5wTBkv4+=4HhPiG4Q@mail.gmail.com>
Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD notes
 in page-size boundary
From: Yanfei Zhang <zhangyanfei.yes@gmail.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: zhangyanfei@cn.fujitsu.com, kexec@lists.infradead.org,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        vgoyal@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>:
> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary
> Date: Thu, 7 Mar 2013 18:11:30 +0800
>
>> 于 2013年03月02日 16:37, HATAYAMA Daisuke 写道:
>>> Fill both crash_notes and vmcoreinfo_note buffers by NT_VMCORE_PAD
>>> note type to make them satisfy mmap()'s page-size boundary
>>> requirement.
>>>
>>> So far, end of note segments has been marked by zero-filled elf
>>> header. Instead, this patch writes NT_VMCORE_PAD note in the end of
>>> note segments until the offset on page-size boundary.
>>
>>
>> In the codes below, it seems that you assign name "VMCOREINFO" for
>> note type NT_VMCORE_PAD, right? This is kind of wired, i think. This
>> name has been used for NT_VMCORE_DEBUGINFO note already. Why not something
>> like "VMCOREPAD" or "PAD"?
>>
>
> It looks you are confusing or don't know name and type. The name is
> namespace and in the namespace, there are multiple note types, each of
> which has the corresponding data. In other words, data corresponding
> to types differ if they belong to differnet name space even if
> integers of the types are coincide with.

Yes, I knew this. Just as the spec said " a program must recognize both the name
and the type to recognize a descriptor.". But I cannot understand what your word
"namespace" came from? I think you complicate simple things here.

Only with a type, we cannot recognize a descriptor, because "multiple
interpretations of
a single type value may exist", So we should combine the name and the type
together. If both the name and type of two descriptors are the same,
we could say we
have two same descriptors. If one of them (type or name) are
different, we say the
two descriptors are different and the two notes have different data.

If I am wrong, please correct me.

>
> The "VMCOREINFO" name represents information exported from
> /proc/vmcore that is used in kdump framework. In this sense,
> NT_VMCORE_PAD that is specific for /proc/vmcore and kdump framework,
> should belong to the "VMCOREINFO" name.

I cannot understand the name explanation totally. Does the name really
have this meaning? Is there any authentic document? I was always thinking we
could feel free to name a name by ourselves!

>
> Thanks.
> HATAYAMA, Daisuke
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
