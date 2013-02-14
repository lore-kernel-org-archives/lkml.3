Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398Ab3BNA10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 19:27:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46342 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3BNA1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 19:27:25 -0500
Message-ID: <511C2F0C.3060803@zytor.com>
Date: Wed, 13 Feb 2013 16:25:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>      <1360355671.18083.18.camel@x230.lan>      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>      <1360373383.18083.23.camel@x230.lan>      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>  <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan> <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com> <511C1A94.8020804@schaufler-ca.com>
In-Reply-To: <511C1A94.8020804@schaufler-ca.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 02:58 PM, Casey Schaufler wrote:
>>
>> This is exactly the kind of thinking which has led to the capability
>> system being so bloody useless.
> 
> The reason the capability system is "bloody useless" is
> that no one wants to update the core system applications to
> use it in favor of good old fashioned worked for dad and
> works for me too superuser.
> 

Because, in large part because a bunch of the capabilities are so close
to equivalent to "superuser" that the distinction is meaningless... so
why go through the hassle?  (This is especially so since it was a *long*
time before the filesystem had any notion of capabilities, and so you
had to make your app run as root anyway before you could drop the
capabilities... and some of the people who tried failed spectacularly
and opened up new security holes.)

> 
> I understand that you want capabilities to be associated with
> resources. That is *not* what we have, and arguing that its
> what we should have is pointless because Linux does not even
> have a concept of resources.
> 

OK, fine, call it "activities".  This is still distinct from "usage
models", and that's where we're just broken.

I may look into seeing if there is any sane way we can use the existing
API to define hierarchical capabilities, which at least should let us
split existing capabilities just like we used capabilities to split root.

	-hpa

