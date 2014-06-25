Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaFYW5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:57:39 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:32819 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaFYW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:57:38 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/mod/modpost.c: Fix bug in number_prefix
Organization: D03
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
	<53AADC30.7080401@windriver.com>
X-Hashcash: 1:20:140625:linux-kernel@vger.kernel.org::TiNndBsQynz5POSV:000000000000000000000000000000000097P
X-Hashcash: 1:20:140625:paul.gortmaker@windriver.com::ZBGGCOO3vx6Bh5rj:0000000000000000000000000000000000WqP
X-Hashcash: 1:20:140625:akpm@linux-foundation.org::aBTLsP9yAFmzv7qw:0000000000000000000000000000000000002tiu
X-Hashcash: 1:20:140625:hpa@linux.intel.com::rAZERZ0hfO2OX9xr:0000000000000000000000000000000000000000005V/5
X-Hashcash: 1:20:140625:rusty@rustcorp.com.au::B+PNXB9wdWG8DxiV:00000000000000000000000000000000000000006VNg
Date: Thu, 26 Jun 2014 00:57:33 +0200
In-Reply-To: <53AADC30.7080401@windriver.com> (Paul Gortmaker's message of
	"Wed, 25 Jun 2014 10:26:56 -0400")
Message-ID: <8761jooaw2.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> On 14-06-25 04:46 AM, Rasmus Villemoes wrote:
>> The function number_prefix() can currently only return 1 if its
>> argument is the empty string: If line 3 is reached and *sym (now the
>> second character in the argument) is not '.', 0 is returned. However,
>> if that character is '.', the first assignment to c is that same '.',
>> which obviously fails to be a digit.
>
> I'd suggest you expand the commit log to actually list the end-user
> visible symptom and the use case that this actually fixes, since it
> isn't obvious to me at all.

Sorry, it isn't obvious to me either. I just stumbled on it reading the
code; the rest of modpost.c is too deep magic for me.

Maybe there are no user-visible symptoms, and maybe that means it is not
worth fixing, in which case I'll just add scripts/mod/modpost.c to my
mental .ocpdignore.

Thanks,
Rasmus
