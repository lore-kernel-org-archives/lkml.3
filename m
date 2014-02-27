Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaB0Dn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:43:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaB0Dn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:43:26 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1393472326.24588.82.camel@joe-AO722>
References: <530E6F76.1070605@zytor.com> <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com> <1393472326.24588.82.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 26 Feb 2014 19:42:37 -0800
To: Joe Perches <joe@perches.com>, Ben Pfaff <blp@nicira.com>,
        Christopher Li <sparse@chrisli.org>
CC: Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(_Bool), like for many other types, is ABI-dependent, but that doesn't mean it is illegitimate.

I don't think C99 says that it is invalid (which means C99 doesn't permit is to be a packed bitmap.)

On February 26, 2014 7:38:46 PM PST, Joe Perches <joe@perches.com> wrote:
>(adding Ben Pfaff and Christopher Li)
>
>On Wed, 2014-02-26 at 19:29 -0800, H. Peter Anvin wrote:
>> On 02/26/2014 06:58 PM, Josh Triplett wrote:
>> > On Wed, Feb 26, 2014 at 06:53:14PM -0800, Joe Perches wrote:
>> >> Allow an override to emit or not the sizeof(bool) warning
>> >> Add a description to the manpage.
>> >>
>> >> Signed-off-by: Joe Perches <joe@perches.com>
>> > 
>> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>> > 
>> 
>> I have to admit that this particular warning is a bit odd to me.  I'm
>> wondering what kind of bugs it was intended to catch.
>> 
>> In particular, things that incorrectly assumes the size of bool to be
>> anything in particular would seem unlikely to actually use sizeof().
>
>Dunno, the commit log for the commit that added it doesn't quite
>match the code and is seemingly unaware that the c99 spec doesn't
>specify sizeof(bool).
>
>Ben Pfaff <blp@nicira.com>
>Date:   Wed May 4 16:39:54 2011 -0700
>
>    evaluate: Allow sizeof(_Bool) to succeed.
>    
> Without this commit, sizeof(_Bool) provokes an error with "cannot size
>expression" because _Bool is a 1-bit type and thus not a multiple of a
>full
>byte in size.  But sizeof(_Bool) is valid C that should evaluate to 1,
>so
>    this commit fixes the problem and adds a regression test.
>    
>    Signed-off-by: Ben Pfaff <blp@nicira.com>
>    Signed-off-by: Christopher Li <sparse@chrisli.org>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
