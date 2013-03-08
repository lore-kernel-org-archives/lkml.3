Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3CHBz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:55:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45887 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3CHBz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:55:27 -0500
Date: Fri, 08 Mar 2013 10:55:19 +0900 (JST)
Message-Id: <20130308.105519.82764856.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: kexec@lists.infradead.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        akpm@linux-foundation.org, cpw@sgi.com, vgoyal@redhat.com
Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD
 notes in page-size boundary
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <513867D2.7090501@cn.fujitsu.com>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083714.31252.17863.stgit@localhost6.localdomain6>
	<513867D2.7090501@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary
Date: Thu, 7 Mar 2013 18:11:30 +0800

> 于 2013年03月02日 16:37, HATAYAMA Daisuke 写道:
>> Fill both crash_notes and vmcoreinfo_note buffers by NT_VMCORE_PAD
>> note type to make them satisfy mmap()'s page-size boundary
>> requirement.
>> 
>> So far, end of note segments has been marked by zero-filled elf
>> header. Instead, this patch writes NT_VMCORE_PAD note in the end of
>> note segments until the offset on page-size boundary.
> 
> 
> In the codes below, it seems that you assign name "VMCOREINFO" for
> note type NT_VMCORE_PAD, right? This is kind of wired, i think. This
> name has been used for NT_VMCORE_DEBUGINFO note already. Why not something
> like "VMCOREPAD" or "PAD"?
> 

It looks you are confusing or don't know name and type. The name is
namespace and in the namespace, there are multiple note types, each of
which has the corresponding data. In other words, data corresponding
to types differ if they belong to differnet name space even if
integers of the types are coincide with.

The "VMCOREINFO" name represents information exported from
/proc/vmcore that is used in kdump framework. In this sense,
NT_VMCORE_PAD that is specific for /proc/vmcore and kdump framework,
should belong to the "VMCOREINFO" name.

Thanks.
HATAYAMA, Daisuke

