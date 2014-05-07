Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaEGPYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaEGPYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:24:17 -0400
Message-ID: <536A5010.6040206@redhat.com>
Date: Wed, 07 May 2014 17:24:00 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: mtosatti@redhat.com, hpa@zytor.com, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Wrong register masking in 64-bit mode
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>	<1399465972-4026-5-git-send-email-namit@cs.technion.ac.il> <jpglhudej88.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpglhudej88.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 16:50, Bandan Das ha scritto:
>> > +static void assign_masked(ulong *dest, ulong src, int bytes)
>> >  {
>> > -	*dest = (*dest & ~mask) | (src & mask);
>> > +	switch (bytes) {
>> > +	case 2:
>> > +		*dest = (u16)src | (*dest & ~0xfffful);
>> > +		break;
>> > +	case 4:
>> > +		*dest = (u32)src;
>> > +		break;
>> > +	case 8:
>> > +		*dest = src;
>> > +		break;
>> > +	default:
>> > +		BUG();
> IIRC, Paolo mentioned that a WARN() is preferable. But I see
> a lot other places where BUG() is called, maybe, he can confirm.
>

There is really no reason to crash the host for a misused API, so I do 
believe that a WARN() is preferable.

Paolo
