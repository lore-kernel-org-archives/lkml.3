Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab3BHWbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:31:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37436 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3BHWbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:31:14 -0500
Message-ID: <51157C9C.6030501@zytor.com>
Date: Fri, 08 Feb 2013 14:30:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <20130208191213.GA25081@www.outflux.net> <00780235-deac-4f80-b936-867834e05661@email.android.com> <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com> <5115553A.5000708@zytor.com> <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com> <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com> <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com> <1360355671.18083.18.camel@x230.lan> <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
In-Reply-To: <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 01:02 PM, Kees Cook wrote:
> On Fri, Feb 8, 2013 at 12:34 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
>> On Fri, 2013-02-08 at 12:28 -0800, Kees Cook wrote:
>>
>>> Maybe a capability isn't the right way to go, I'm not sure. I'll leave
>>> that to Matthew. Whatever the flag, it should be an immutable state of
>>> the boot. Though, it probably makes sense as a cap just so that
>>> non-secure-boot systems can still remove it from containers, etc.
>>
>> There was interest in ensuring that this wasn't something special-cased
>> to UEFI Secure Boot, so using a capability seemed like the most
>> straightforward way - it's fundamentally a restriction on what an
>> otherwise privileged user is able to do, so it seemed like it fit the
>> model. But I'm not wed to it in the slightest, and in fact it causes
>> problems for some userspace (anything that drops all capabilities
>> suddenly finds itself unable to do something that it expects to be able
>> to do), so if anyone has any suggestions for a better approach…
> 
> I don't find it unreasonable to drop all caps and lose access to
> sensitive things. :) That's sort of the point, really. I think a cap
> is the best match. It seems like it should either be a cap or a
> namespace flag, but the latter seems messy.
> 

Caps are fine; the problem is the "putting it all under one cap".  The
semi-problem here is that to preserve backwards compatibility we really
should have a way to have hierarchical caps in Linux (which we currently
don't), but it is not really an issue for this.

Also, keep in mind that there is a very simple way to deny MSR access
completely, which is to not include the driver in your kernel (and not
allow module loading, but if you can load modules you can just load a
module to muck with whatever MSR you want.)

I am still wondering if there are any legitimate uses of CAP_RAWIO &
~CAP_COMPROMISE_KERNEL that can't be used to subvert the latter.  I am
not sure there are.

	-hpa

