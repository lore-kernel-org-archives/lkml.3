Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876Ab3GRXrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:47:05 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54020 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934780Ab3GRXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130718143928.4f9b45807956e2fdb1ee3a22@linux-foundation.org>
References: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
	<20130718143928.4f9b45807956e2fdb1ee3a22@linux-foundation.org>
Date: Fri, 19 Jul 2013 07:47:02 +0800
Message-ID: <CAAV+Mu7A5H_T2EroUDWaCSOs1j5_Z6hRNyzrwU2N1WPAOZ=JDw@mail.gmail.com>
Subject: Re: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
From: Jerry <uulinux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhuwei.lu@archermind.com, tianfu.huang@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/19 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 19 Jul 2013 00:56:12 +0800 Jerry <uulinux@gmail.com> wrote:
>
>> When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
>> calculating here will generate an unexpected result. In addition, if
>> PAGE_SHIFT > 20, The memory size represented by numentries was already
>> integral multiple of 1MB.
>>
>
> If you tell me that you have a machine which has PAGE_SIZE=2MB and this
> was the only problem which prevented Linux from running on that machine
> then I'll apply the patch ;)
>

Hi Morton:
I just "grep -rn "#define\s\+PAGE_SHIFT" arch/", and find the
PAGE_SHIFT in some architecture is very big.
such as the following in "arch/hexagon/include/asm/page.h"
....
#ifdef CONFIG_PAGE_SIZE_256KB
#define PAGE_SHIFT 18
#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_256KB
#endif

#ifdef CONFIG_PAGE_SIZE_1MB
#define PAGE_SHIFT 20
#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_1MB
#endif
.....

Maybe the day of "A 2MB page" is not far. :-) I know it is just a
latent issue. Even if it won't generate a error when PAGE_SIZE == 20,
the calculating here is not necessary. In my mind, compiler would
optimize the calculating at that situation. But it is a little tricky.

In my patch, I think compiler would optimize "if (20 > PAGE_SIZE)", it
won't generate any machine instruction. Just a guarantee.

--
I love linux!!!
