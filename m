Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3APHCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:02:33 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:35411 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3APHCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <50F61061.4040201@zytor.com>
References: <50F606A8.2080804@palosanto.com>
	<50F61061.4040201@zytor.com>
Date: Tue, 15 Jan 2013 23:02:29 -0800
X-Google-Sender-Auth: wE27PCbhATCLWH787GrupoCDf9c
Message-ID: <CAE9FiQUPBGi8kQ2bA2mdWz_gO1R9UmM-QdWXzEfTh6K0i+ZkGg@mail.gmail.com>
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range - is
 this safe?
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 6:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/15/2013 05:47 PM, Alex Villacís Lasso wrote:

>> 2) I have recompiled the kernel to support the memtest parameter. When
>> using it, the extra memory segment appears to be as healthy as other
>> areas of memory. However this might only mean that it is wrapping into
>> healthy low RAM.

memtest should print out about the range.

and if you are using 64bit kernel, it should test all memory
except for range with kernel itself.


>>
>> Is my reasoning sane? Is there a way to know, once and for all, whether
>> the extra "memory" is real and safe to use or not?
>
>
> Maybe you can get memtest86+ to test this phantom memory?  But yes, it does
> sound like a BIOS bug.

that may not help, because e820 from bios is not right.

Yinghai
