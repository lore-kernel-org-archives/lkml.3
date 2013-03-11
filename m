Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3CKAbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:31:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54930 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3CKAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:31:44 -0400
Date: Mon, 11 Mar 2013 09:31:41 +0900 (JST)
Message-Id: <20130311.093141.331282420.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: kexec@lists.infradead.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        akpm@linux-foundation.org, cpw@sgi.com, vgoyal@redhat.com
Subject: Re: [PATCH v2 01/20] vmcore: refer to e_phoff member explicitly
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <513C2C47.5020008@cn.fujitsu.com>
References: <20130302083554.31252.30615.stgit@localhost6.localdomain6>
	<5135A054.7010401@cn.fujitsu.com>
	<513C2C47.5020008@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 01/20] vmcore: refer to e_phoff member explicitly
Date: Sun, 10 Mar 2013 14:46:31 +0800

> 于 2013年03月05日 15:35, Zhang Yanfei 写道:
>> 于 2013年03月02日 16:35, HATAYAMA Daisuke 写道:
<cut>
> 
> One minor suggestion.
> 
> Previously, when the code assumes program headers are following immediately
> the ELF header, it uses
> 
>  elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
> 
> to calculate the size of ELF header and ELF program headers
> 
> This patch avoids the assumption, and uses ehdr.e_phoff to get the program
> headers' address. But it will read unrelated contents into elfcorebuf if
> program headers are not following immediately the ELF header. So could the
> code be:
> 
> elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
> addr = elfcorehdr_addr + ehdr.e_phoff;
> memcpy(elfcorebuf, &ehdr, sizeof(Elf64_Ehdr));
> read_from_oldmem(elfcorebuf + sizeof(Elf64_Ehdr), elfcorebuf_sz -
>                  sizeof(Elf64_Ehdr), &addr, 0);
> (Elf64_Ehdr *)elfcorebuf->e_phoff = sizeof(Elf64_Ehdr);

Thanks. This is not minor suggestion. This is critical. My code is
completely broken. On ELF, segments and headers other than ELF header
can occur in any positions. This means program header table can occur
after segments. So, on terabyte systems, e_phoff can be more than
terabytes.

Sorry, this was due to my carelessness.

Thanks.
HATAYAMA, Daisuke

