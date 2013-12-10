Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3LJAll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:41:41 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55174 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3LJAlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:41:39 -0500
MIME-Version: 1.0
In-Reply-To: <52A66235.3010405@zytor.com>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<52A6389E.90404@zytor.com>
	<CAMe9rOpuFzqA7tOGZ3Eh8Vb76+Y5T2xirAfB08NHbSS5R-OjuQ@mail.gmail.com>
	<52A653C4.1050208@zytor.com>
	<CAMe9rOpuf1=LPBJzUHmgb2x6WDu=yUsKE+iZansaPDQfCPaejw@mail.gmail.com>
	<52A66235.3010405@zytor.com>
Date: Mon, 9 Dec 2013 16:41:38 -0800
Message-ID: <CAMe9rOrKQFnzZH+=rnbnfeK1BzZZE-O7SGNA9QnxvHmByWRyTA@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 4:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2013 03:53 PM, H.J. Lu wrote:
>>>>
>>>> x86-64 small model is limited to 4GB in size.  You can't build
>>>> a dynamic executable in small model larger than 4GB.
>>>>
>>>> There are medium and large models.  But they are slower than
>>>> small models as well as small models in PIE.  Also there are
>>>> no glibc run-times for medium and large models.
>>>>
>>> Compiling for the small PIC model shouldn't automatically mean
>>> generating a PIE (ET_DYN) executable, though (and if those are
>>> inherently linked, that is a fundamental bug IMNSHO.)
>>
>> PIE uses PIC. But GCC has -fPIE and -fPIC.  They aren't
>> the same.   You build PIE with
>>
>> 1. Compile with -fPIE.
>> 2. Link with -pie.
>>
>
> I'm talking about the memory model ("small PIC model").  I don't see why
> it should be encapsulated in a PIE (ET_DYN) container if the user
> doesn't want it to be relocatable.
>

I see.  Maybe linker can set ET_EXEC if vaddr is non-zero.


-- 
H.J.
