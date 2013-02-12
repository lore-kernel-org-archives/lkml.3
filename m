Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346Ab3BLQii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:38:38 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34795 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab3BLQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <5119C34B.70207@zytor.com>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
	<tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
	<CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
	<5119C34B.70207@zytor.com>
Date: Tue, 12 Feb 2013 08:38:36 -0800
Message-ID: <CAMe9rOrTLGJvO+Z8kCG3gmOuW-Yq2Ex9WMfJZ5wmZcbz+zm94Q@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 8:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/11/2013 07:33 PM, Linus Torvalds wrote:
>> On Mon, Feb 11, 2013 at 5:37 PM, tip-bot for H. Peter Anvin
>> <hpa@zytor.com> wrote:
>>>
>>> However, we can declare a bitfield using sizeof(), which is legal
>>> because sizeof() is a constant expression.  This quiets the warning,
>>> although the code generated isn't 100% identical from the baseline
>>> before 96477b4 x86-32: Add support for 64bit get_user():
>>
>> Christ. This is so ugly that it's almost a work of art.
>
> :)
>
>> Has anybody run this past any gcc developers? And if so, did they run
>> away screaming?
>
> I haven't no... H.J., any comments on this patch?
>

Can you do something similar to what we did in glibc:

http://sourceware.org/git/?p=glibc.git;a=patch;h=c515fb5148f1d81d5f7736825e14c7502c15432a

-- 
H.J.
