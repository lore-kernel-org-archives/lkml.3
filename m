Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaDVRTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:19:48 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46192 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaDVRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
	<5355A9E9.9070102@zytor.com>
	<CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
	<1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com>
	<CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>
	<a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com>
	<CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
	<ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>
	<CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
	<20140422112312.GB15882@pd.tnic>
	<20140422144659.GF15882@pd.tnic>
	<CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
	<53569467.1030809@zytor.com>
	<CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
	<CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
	<CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
	<CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>
	<CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>
Date: Tue, 22 Apr 2014 10:19:46 -0700
X-Google-Sender-Auth: 6QeLscCDh6qtega55ULfSpzCWMk
Message-ID: <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Lutomirski <amluto@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:11 AM, Andrew Lutomirski <amluto@gmail.com> wrote:
>
>>
>> Anyway, if done correctly, this whole espfix should be totally free
>> for normal processes, since it should only trigger if SS is a LDT
>> entry (bit #2 set in the segment descriptor). So the normal fast-path
>> should just have a simple test for that.
>
> How?  Doesn't something still need to check whether SS is funny before
> doing iret?

Just test bit #2. Don't do anything else if it's clear, because you
should be done. You don't need to do anything special if it's clear,
because I don't *think* we have any 16-bit data segments in the GDT on
x86-64.

              Linus
