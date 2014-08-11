Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaHKOyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:54:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52618 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbaHKOyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:54:21 -0400
Message-ID: <53E8D905.7030809@zytor.com>
Date: Mon, 11 Aug 2014 07:53:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>
CC: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <20140801231929.GB26491@localhost.localdomain> <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com> <20140811004559.GA2656@lerouge> <53E89DA3020000780002B00B@mail.emea.novell.com> <53E8C476.8000800@redhat.com> <53E8EC9F020000780002B383@mail.emea.novell.com>
In-Reply-To: <53E8EC9F020000780002B383@mail.emea.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 07:17 AM, Jan Beulich wrote:
>>
>> The existing comments explain what every byte means.
>> They are useful if CFI-literate reader wants to check correctness
>> of the encoding of this annotation.
>>
>> There is no overall comment what this CFI annotation
>> *achieves*. In human language, what do we say
>> to DWARF decoder here?
> 
> Short answer: DW_CFA_def_cfa_expression.
> 
> Longer response: Just like I said before, what you're asking for is
> identical to ask for each other CFI annotation to get a comment
> associated to tell you what it's doing, which I don't think you
> really mean to ask for. (Our main problem here is that we can't
> specify expressions with the .cfi_* gas directives, and hence have
> to resort to .cfi_escape.)
> 

No, in *human language*.  What does the DW_CFA_def_cfa_expression
actually aim to accomplish?  If you don't know the innards of the DWARF
spec, the whole thing might as well be Hungarian.

	-hpa

