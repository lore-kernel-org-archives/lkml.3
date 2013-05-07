Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab3EGNkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:24325 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab3EGNkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:00 -0400
Message-ID: <5189042A.6050302@imgtec.com>
Date: Tue, 7 May 2013 14:39:54 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: h8300 SYMBOL_NAME() breakage
References: <CAMuHMdXBk0oZUufY3KoFaZiawRHdm9juMqHPMTftqcjQDXnUgw@mail.gmail.com>
In-Reply-To: <CAMuHMdXBk0oZUufY3KoFaZiawRHdm9juMqHPMTftqcjQDXnUgw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_07_14_39_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/13 13:31, Geert Uytterhoeven wrote:
> Commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate cond_syscall
> and SYSCALL_ALIAS declarations") broke the h8300 build because it removed
> the duplicate SYMBOL_NAME from arch/h8300/include/asm/linkage.h, and all
> the h8300 asm files include <asm/linkage.h> instead of <linux/linkage.h>.
> (yes, this was in -next).
> 
> Commit 126de6b20bfb82cc19012d5048f11f339ae5a021 ("linkage.h: fix build
> breakage due to symbol prefix handling") broke it even more, by removing
> SYMBOL_NAME() and replacing it by __SYMBOL_NAME().

Yes, sorry about that. I had assumed h8300 still referred to it's own
definition of SYMBOL_NAME from arch/h8300/include/asm/linkage.h, which
was still intact on modules-next where I had last checked it.

Cheers
James

