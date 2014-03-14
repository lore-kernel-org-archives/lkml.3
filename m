Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaCNUPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:15:10 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40532 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCNUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyEu4POnixwxFCt+a8-ZJYBK-tCrdAP1yYgCPXq8x3ANg@mail.gmail.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
	<20140313231227.GA32178@redhat.com>
	<CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
	<20140314190824.GA6426@redhat.com>
	<CA+55aFznCT20giHq8JxCRduky-dQtVLqpUYrcrK_3XeXN+Wyow@mail.gmail.com>
	<CA+55aFyEu4POnixwxFCt+a8-ZJYBK-tCrdAP1yYgCPXq8x3ANg@mail.gmail.com>
Date: Fri, 14 Mar 2014 13:15:02 -0700
X-Google-Sender-Auth: 8ilpq70OSte53cCp6EW9KKalWZg
Message-ID: <CAGXu5jKbvXdtOQMVV3Jig-cCd=yfMYTF5gZSReAxkEEfs198ow@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 14, 2014 at 12:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Hmm. Do you have CONFIG_KALLSYMS enabled?
>
> Just to clarify. KALLSYMS is required to figure out the symbol
> addresses on a kaslr system. There's no way to look them up in a
> System.map file or the object file, since the addresses aren't going
> to match.
>
> Your symptoms really sound like you might not have KALLSYMS enabled.
>
> I wonder if we have a "select KALLSYMS" as part of RANDOMIZE_BASE,
> since you need it for debug messages too (random hex numbers aren't
> too useful ;)

My weak preference would be to allow to build without that hard
requirement (citing imagined space savings, blah blah). But since
everything I normally use has KALLSYMS, I wouldn't object to doing it
either. :)

-Kees

-- 
Kees Cook
Chrome OS Security
