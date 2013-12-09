Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718Ab3LIWD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:03:26 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60842 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3LIWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <52A63DCF.2060504@zytor.com>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
	<52A63AD4.2030101@zytor.com>
	<CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
	<52A63BF3.1000608@zytor.com>
	<CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
	<52A63DCF.2060504@zytor.com>
Date: Mon, 9 Dec 2013 14:03:24 -0800
Message-ID: <CAMe9rOqAV5_+H97XSnrOHxcruouC=hCjDuEkiiyM8UM0BH5CWw@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 2:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2013 01:59 PM, H.J. Lu wrote:
>>
>> A Linux/x86-64 user came to me at the end of 2008.  He needed
>> to load an executable above 4GB.  I added -Ttext-segment option
>> to linker:
>>
>> https://sourceware.org/ml/binutils/2009-01/msg00173.html
>>
>> so that he could load his program compiled as PIE above 4GB.
>> If kernel is changed not to honor it, his program won't work any more.
>> In normal case, PIE has zero vaddr and this doesn't apply.
>>
>
> That doesn't seem to be PIE at all, and if it is PIE, then it should be
> relocatable (I agree btw with randomizing upward from the selected address.)
>

Kernel can consider PIE with non-zero vaddr isn't real PIE.

-- 
H.J.
