Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3CUC72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:59:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36098 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CUC71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:59:27 -0400
Date: Thu, 21 Mar 2013 11:59:20 +0900 (JST)
Message-Id: <20130321.115920.339923125.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark
 indicating the end of ELF note buffer
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87ppyvp014.fsf@xmission.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040223.15064.77472.stgit@localhost6.localdomain6>
	<87ppyvp014.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer
Date: Tue, 19 Mar 2013 14:11:51 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
>> Modern kernel marks the end of ELF note buffer with NT_VMCORE_PAD type
>> note in order to make the buffer satisfy mmap()'s page-size boundary
>> requirement. This patch makes finishing reading each buffer if the
>> note type now being read is NT_VMCORE_PAD type.
> 
> Ick.  Even with a pad header you can mark the end with an empty header,
> and my memory may be deceiving me but I believe an empty header is
> specified by the ELF ABI docs.
> 
> Beyond which I don't quite see the point of any of this as all of these
> headers need to be combined into a single note section before being
> presented to user space.

Though this patch might get unecessary later, I cannot find part
explaining necessity of marking end of ELF segmetns with an empty
header in ELF spec. For example:

gabi
http://www.sco.com/developers/gabi/latest/ch5.pheader.html#note_section

AMD64
http://www.x86-64.org/documentation/abi.pdf

But still there's possibility of another particular spec that says
necessity of empty header.

Also, it's possible to get size of a whole part of ELF note segments
from p_memsz or p_filesz, and gdb and binutils are reading the note
segments until reaching the size.

Thanks.
HATAYAMA, Daisuke

