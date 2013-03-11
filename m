Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3CKA2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:28:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54762 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3CKA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:28:08 -0400
Date: Mon, 11 Mar 2013 09:27:19 +0900 (JST)
Message-Id: <20130311.092719.142837234.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] vmcore: copy non page-size aligned head and
 tail pages in 2nd kernel
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <513C2553.5050402@cn.fujitsu.com>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083627.31252.41277.stgit@localhost6.localdomain6>
	<513C2553.5050402@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 07/20] vmcore: copy non page-size aligned head and tail pages in 2nd kernel
Date: Sun, 10 Mar 2013 14:16:51 +0800

> 于 2013年03月02日 16:36, HATAYAMA Daisuke 写道:
<cut>
>>  		/* Update the program header offset. */
>>  		phdr_ptr->p_offset = vmcore_off;
>> -		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
>> +		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
> 
> Here the code changes phdr_ptr->p_offset to a new page-size aligned offset.
> But it seems the phdr_ptr->p_paddr is still the non page-size aligned
> physical address? Does the mismatch of a PT_LOAD segment and the physical
> memory occur?
> 
> Or, later in makedumpfile, it will check the phdr_ptr->paddr to see if it
> is page-size aligned and also phdr_ptr->p_memsz to get the real memory size,
> not including padding?
> 

No, it doesn't happen. p_offset is made page-size aligned for
requirement to user-space linear-address vs file offset. The
requirement for physical address is handled internally in vmcore_list,
which is transparent to to user-space.

Thanks.
HATAYAMA, Daisuke

