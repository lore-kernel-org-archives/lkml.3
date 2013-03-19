Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3CSTht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:37:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CSThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:37:48 -0400
Date: Tue, 19 Mar 2013 12:37:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 08/21] vmcore: copy non page-size aligned head and
 tail pages in 2nd kernel
Message-Id: <20130319123746.595a38d90c6071730ed6364b@linux-foundation.org>
In-Reply-To: <20130316040132.15064.42257.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040132.15064.42257.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 13:01:32 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> Due to mmap() requirement, we need to copy pages not starting or
> ending with page-size aligned address in 2nd kernel and to map them to
> user-space.
> 
> For example, see the map below:
> 
>     00000000-00010000 : reserved
>     00010000-0009f800 : System RAM
>     0009f800-000a0000 : reserved
> 
> where the System RAM ends with 0x9f800 that is not page-size
> aligned. This map is divided into two parts:
> 
>     00010000-0009f000
>     0009f000-0009f800
> 
> and the first one is kept in old memory and the 2nd one is copied into
> buffer on 2nd kernel.
> 
> This kind of non-page-size-aligned area can always occur since any
> part of System RAM can be converted into reserved area at runtime.
> 
> If not doing copying like this and if remapping non page-size aligned
> pages on old memory directly, mmap() had to export memory which is not
> dump target to user-space. In the above example this is reserved
> 0x9f800-0xa0000.

Ah.  This is all the missing info from [patch 07/21].  I suggest we
join 7 and 8 into a single patch, use the above changelog, add the
MEM_TYPE_CURRENT_KERNEL code comments.

