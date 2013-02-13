Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340Ab3BMT4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:56:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961Ab3BMTzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:55:50 -0500
Message-ID: <511BEFAD.1050206@redhat.com>
Date: Wed, 13 Feb 2013 20:55:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>    <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>    <1360355671.18083.18.camel@x230.lan>    <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>    <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>    <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>    <1360373383.18083.23.camel@x230.lan>    <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>    <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>   <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>  <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan> <511B33BC.9080307@zytor.com> <511B4E61.1040604@redhat.com> <511BCBD6.6020907@zytor.com>
In-Reply-To: <511BCBD6.6020907@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/02/2013 18:22, H. Peter Anvin ha scritto:
>>
>> On non-x86 machines CAP_SYS_RAWIO is much less dangerous, especially
>> when coupled with file DAC.

Discretionary Access Control.

> Either way, I think you are at best deluded and more like you just
> completely wrong about CAP_SYS_RAWIO being "less dangerous on non-x86
> machines".  With the possible exception of s390 I suspect it is, in
> fact, more dangerous.

I may well be wrong, but as a quick data point CAP_SYS_RAWIO has no
occurrences in arch/ except arch/x86.  Of course a lot of driver
functionality will be limited to CAP_SYS_RAWIO, but usually this
requires having a file descriptor for some file.

Paolo
