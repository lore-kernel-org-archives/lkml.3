Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3FZClv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:41:51 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:1166 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab3FZCls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:41:48 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>
Date: Wed, 26 Jun 2013 10:41:40 +0800
Subject: ARM pagetable setting in Linux 
Thread-Topic: ARM pagetable setting in Linux 
Thread-Index: Ac5yFq/ukbzQ3tr2QI2PQwwF5C8inQ==
Message-ID: <35FD53F367049845BC99AC72306C23D19441BF5863@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q2fwlx002811

Hi  Will,

I have a question about  arm pagetable setting in Linux .

>From armV6,  there is TTBR0 and TTBR1  translation base address registers  in mmu .
But I  found linux only use TTBR0 for translation base address ,
Could we use TTBR0 and TTBR1 to split user task and kernel pagetables (swapper_pg_dir)ï¼Ÿ 

But I found this need set TTBCR.N   ,
If PAGE_OFFSET==0xc0000000  ,   set TTBCR.N=0x2 ,
Will not work , because   only ensure 0--0x00FFFFFF  MVA use TTBCR0 
And other  MVAã€€will use TTBCR1 ,
But if we set PAGE_OFFSET==0x80000000  (2GB split )  ,
And set  TTBCR.N=0x1 ,
This will make sure user task MVA use TTBCR0 and kernel  MVA 
Use TTBCR1 , this  will make some improvement for the system .

1. Because we donâ€™t need copy kernel first â€“level pagetables into every 
User taskâ€™s pagetables and flush tlb (for example fork() a new process).

2. And donâ€™t need handle kernel page fault because that user taskâ€™s kernel 
Pagetable when it is not set up , need copy again( for example vmalloc()  ioremap()  kmap()  will change 
Kernel pagetables and need update to every task pagetables ) .

3. We  even can only allocate 8KB first level pagetables for user task to save 
Memorys .


I am not  sure if its possible to implement this on cortex-A  cpus ?
And if there is some side effects if we use this in linux ?

If possible ,  I can make a change to do some test .

Thanks for your help .







Yalin.Wang
Software Engineer 
OS Kernel&Graphics
Â 
Sony Mobile Communications
Tel: +86 10 5966 9819
Phone: 18610323092
Address: No.16 Guangshun South Street, Chaoyang, Beijing, P.R.C.

sonymobile.com
Â Â 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
