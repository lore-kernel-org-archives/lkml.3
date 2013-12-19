Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3LSUbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:31:31 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36132 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3LSUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwu_KN+1Ep5RmgFTvBdH3xRJDmCjZ9Fo_pH28hTdiHyiQ@mail.gmail.com>
References: <20131219040738.GA10316@redhat.com>
	<CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
	<20131219155313.GA25771@redhat.com>
	<CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
	<20131219181134.GC25385@kmo-pixel>
	<20131219182920.GG30640@kvack.org>
	<CA+55aFzCo_r7ZGHk+zqUjmCW2w7-7z9oxEJjhR66tZ4qZPxnvw@mail.gmail.com>
	<20131219192621.GA9228@kvack.org>
	<CA+55aFz=tEkVAx9VndtCXApDxcw+5T-BxMsVuXp+vMSb05f8Aw@mail.gmail.com>
	<20131219195352.GB9228@kvack.org>
	<CA+55aFy5zg_cJueMZFzuqr06rT-hwnHhvBpM6W9657sxnCzxKg@mail.gmail.com>
	<CA+55aFwu_KN+1Ep5RmgFTvBdH3xRJDmCjZ9Fo_pH28hTdiHyiQ@mail.gmail.com>
Date: Fri, 20 Dec 2013 05:31:29 +0900
X-Google-Sender-Auth: oRA3bRE508sTfbFQoqv0v6SJ1NU
Message-ID: <CA+55aFzW_MKS35Mn9cfZV2A4BH_ONZCmmdk1pQtztbxwPYsxpA@mail.gmail.com>
Subject: Re: bad page state in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 5:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So here's the same patch, but with stuff moved around a bit, and the
> "oops, couldn't create page" part fixed.
>
> Bit it's still totally and entirely untested.

Btw, I think this actually fixes a bug, in that it doesn't leak the
page reference count if the do_mmap_pgoff() call fails.

That said, that looks like just a memory leak, not explaining the
problem Dave sees. And maybe I'm missing something.

And no, I still haven't actually tested this at all. Is there an aio
tester that is worth trying?

                   Linus
