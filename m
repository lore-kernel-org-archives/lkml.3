Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaGKSkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:40:07 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55772 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaGKSkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140711181212.GT18735@two.firstfloor.org>
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
 <20140711181212.GT18735@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Jul 2014 11:39:41 -0700
Message-ID: <CALCETrWMgTET6MZwaH4D4tOg2v1kV6ozBnjGTGrecnMWJbkUEg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:12 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
>> index 076b11f..df9908b 100644
>> --- a/arch/x86/include/uapi/asm/sigcontext.h
>> +++ b/arch/x86/include/uapi/asm/sigcontext.h
>
> I don't think renaming fields in uapi/asm is acceptable. These
> are likely used by user programs and you'll break compiles.

Hmm.  That's a fair point.  On the other hand, any user code that uses
these fields explicitly may already be broken, since the current names
of these fields rather strongly imply that they do something.

Is there any clear policy on minor API breaks in the UAPI headers that
don't affect ABI?

--Andy
