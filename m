Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3BMGNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:13:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3BMGNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:13:43 -0500
Message-ID: <511B2EB9.5070406@zytor.com>
Date: Tue, 12 Feb 2013 22:12:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>   <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>   <1360355671.18083.18.camel@x230.lan>   <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>   <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>   <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>   <1360373383.18083.23.camel@x230.lan>   <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>   <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>  <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
In-Reply-To: <1360733962.18083.30.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:39 PM, Matthew Garrett wrote:
> On Tue, 2013-02-12 at 16:48 -0800, H. Peter Anvin wrote:
>
>> OK... what none of this gets into:
>>
>> Why should CAP_RAWIO be allowed on a secure boot system, when there are
>> 2^n known ways of compromise a system with CAP_RAWIO?
>
> CAP_SYS_RAWIO seems to have ended up being a catchall of "Maybe someone
> who isn't entirely root should be able to do this", and not everything
> it covers is equivalent to being able to compromise the running kernel.
> I wouldn't argue with the idea that maybe we should just reappraise most
> of the current uses of CAP_SYS_RAWIO, but removing capability checks
> from places that currently have them seems like an invitation for
> userspace breakage.
>

Sounds like you are thinking of CAP_SYS_ADMIN, but I don't really see a 
huge difference between MSRs and I/O control registers... just different 
address spaces.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

