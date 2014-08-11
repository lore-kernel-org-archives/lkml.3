Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaHKPIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:08:18 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:50436 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaHKPIR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 11 Aug 2014 11:08:17 -0400
Message-Id: <53E8F87B020000780002B41D@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 11 Aug 2014 16:08:11 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Kees Cook" <keescook@chromium.org>, "Will Drewry" <wad@chromium.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>, "X86 ML" <x86@kernel.org>,
        "Alexei Starovoitov" <ast@plumgrid.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete
 "struct pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
 <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
 <20140811004559.GA2656@lerouge>
 <53E89DA3020000780002B00B@mail.emea.novell.com>
 <53E8C476.8000800@redhat.com>
 <53E8EC9F020000780002B383@mail.emea.novell.com>
 <53E8D905.7030809@zytor.com>
In-Reply-To: <53E8D905.7030809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.08.14 at 16:53, <hpa@zytor.com> wrote:
> On 08/11/2014 07:17 AM, Jan Beulich wrote:
>>>
>>> The existing comments explain what every byte means.
>>> They are useful if CFI-literate reader wants to check correctness
>>> of the encoding of this annotation.
>>>
>>> There is no overall comment what this CFI annotation
>>> *achieves*. In human language, what do we say
>>> to DWARF decoder here?
>> 
>> Short answer: DW_CFA_def_cfa_expression.
>> 
>> Longer response: Just like I said before, what you're asking for is
>> identical to ask for each other CFI annotation to get a comment
>> associated to tell you what it's doing, which I don't think you
>> really mean to ask for. (Our main problem here is that we can't
>> specify expressions with the .cfi_* gas directives, and hence have
>> to resort to .cfi_escape.)
>> 
> 
> No, in *human language*.  What does the DW_CFA_def_cfa_expression
> actually aim to accomplish?  If you don't know the innards of the DWARF
> spec, the whole thing might as well be Hungarian.

Just like the other DW_CFA_def_cfa_* ones it sets the current
frame address (CFA), just not via one of the pre-canned shortcuts,
but via an expression (in the case here de-referencing the stack
pointer to read the top of stack, and then adding the necessary
offset). So it indeed is similar enough to other .cfi_* annotations we
use without further comments.

And btw., Hungarian isn't _that_ bad.

Jan

