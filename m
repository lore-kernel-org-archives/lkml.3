Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaDXQXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:23:24 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:45901 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaDXQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <201404221430.40237.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-13-git-send-email-lftan@altera.com>
	<201404221430.40237.arnd@arndb.de>
Date: Fri, 25 Apr 2014 00:23:21 +0800
X-Google-Sender-Auth: 7xO1J4hqTI0zBPcNR9QojAJl9B8
Message-ID: <CAFiDJ58uhQNzzZfpC8k1V628sFD9+GrAAEnHgHM6k1NtxKNGgw@mail.gmail.com>
Subject: Re: [PATCH 16/28] nios2: System calls handling
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 8:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 April 2014, Ley Foon Tan wrote:
>
>> +
>> + #define sys_mmap2 sys_mmap_pgoff
>> +
>
> You use sys_mmap_pgoff here, but
>
>> +asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
>> +                     unsigned long prot, unsigned long flags,
>> +                     unsigned long fd, unsigned long offset)
>> +{
>> +     if (offset & ~PAGE_MASK)
>> +             return -EINVAL;
>> +
>> +     return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
>> +}
>
> define a separate sys_mmap() here. Doing the former should be enough.
> so you can just drop the sys_mmap definition.
Okay, will drop the sys_mmap.

Thanks.
Regards
Ley Foon
