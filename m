Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3EASSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:18:47 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:48526 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3EASSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <518156D3.8020909@zytor.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org>
 <518145F6.3060800@zytor.com> <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
 <51815252.4010103@zytor.com> <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
 <518156D3.8020909@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 May 2013 11:18:19 -0700
Message-ID: <CALCETrXRiZ+5OGauT5bxx0aKMAMmTpO92tjTO9CNfAMOh-VZaA@mail.gmail.com>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 10:54 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2013 10:50 AM, Andy Lutomirski wrote:
>>
>> Isn't the upper half incompatible with large pages?
>>
>
> No, just with attributes *on the page tables themselves*.

Thanks :)  Now I found the somewhat alarming algorithm in section 4.9.2.

This will be a bit unpleasant, though, since the _PAGE_CACHE_xxx
macros will become rather confused.  I suppose there's no fundamental
reason that pgprot_t has to correspond to pmd bit positions.  Sigh.

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
