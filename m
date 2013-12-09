Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639Ab3LIV7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:59:51 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51474 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3LIV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:59:49 -0500
MIME-Version: 1.0
In-Reply-To: <52A63BF3.1000608@zytor.com>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
	<52A63AD4.2030101@zytor.com>
	<CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
	<52A63BF3.1000608@zytor.com>
Date: Mon, 9 Dec 2013 13:59:48 -0800
Message-ID: <CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 1:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2013 01:52 PM, H.J. Lu wrote:
>>>
>>> Why is that?  It would seem to be a big difference between a relocatable
>>> binary (PIE) and one with a load address fixed at link time.
>>>
>>
>> PIE with non-zero vaddr should be loaded at non-zero
>> vaddr.  Otherwise, PIE may not work as expected.
>>
>
> Please explain why that is the case, as it seems to be implying that PIE
> isn't actually relocatable in that case...
>

A Linux/x86-64 user came to me at the end of 2008.  He needed
to load an executable above 4GB.  I added -Ttext-segment option
to linker:

https://sourceware.org/ml/binutils/2009-01/msg00173.html

so that he could load his program compiled as PIE above 4GB.
If kernel is changed not to honor it, his program won't work any more.
In normal case, PIE has zero vaddr and this doesn't apply.

-- 
H.J.
