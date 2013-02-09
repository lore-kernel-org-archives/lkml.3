Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3BIBWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:22:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38880 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab3BIBWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:22:51 -0500
Message-ID: <5115A4CC.3080102@zytor.com>
Date: Fri, 08 Feb 2013 17:22:20 -0800
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
References: <20130208191213.GA25081@www.outflux.net>  <00780235-deac-4f80-b936-867834e05661@email.android.com>  <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>  <5115553A.5000708@zytor.com>  <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>  <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>  <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>  <1360355671.18083.18.camel@x230.lan>  <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>  <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic> <1360366012.18083.21.camel@x230.lan>
In-Reply-To: <1360366012.18083.21.camel@x230.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 03:26 PM, Matthew Garrett wrote:
> On Sat, 2013-02-09 at 00:06 +0100, Borislav Petkov wrote:
>> On Fri, Feb 08, 2013 at 02:30:52PM -0800, H. Peter Anvin wrote:
>>> Also, keep in mind that there is a very simple way to deny MSR access
>>> completely, which is to not include the driver in your kernel (and not
>>> allow module loading, but if you can load modules you can just load a
>>> module to muck with whatever MSR you want.)
>>
>> I was contemplating that too. What is the use case of having
>> msr.ko in a secure boot environment? Isn't that an all-no-tools,
>> you-can't-do-sh*t-except-what-you're-explicitly-allowed-to environment which
>> simply doesn't need to write MSRs in the first place?
> 
> Well, sure, distributions could build every kernel twice. That seems a
> little excessive, though.
> 

You don't have to build the kernel twice to exclude a loadable module.

	-hpa

