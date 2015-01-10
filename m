Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbbAJK1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:27:19 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64036 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbAJK1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <2180.1420801081@warthog.procyon.org.uk>
References: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
	<2180.1420801081@warthog.procyon.org.uk>
Date: Sat, 10 Jan 2015 12:27:16 +0200
Message-ID: <CACE9dm9_8-AK_0tJQ-BzGdBJ6wqTfizYM2pB0ATHhRJP+C2-HQ@mail.gmail.com>
Subject: Re: [Keyrings] [PATCH 1/2] MPILIB: Fix comparison of negative MPIs
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        keyrings <keyrings@linux-nfs.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you. It looks correct.

Ack.

- Dmitry

On 9 January 2015 at 12:58, David Howells <dhowells@redhat.com> wrote:
> I think you're right - *adding* the two sizes makes no sense.  cc'ing Dmitry
> also for his check.
>
> David
>
>
> Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> If u and v both represent negative integers and their limb counts
>> happen to differ, mpi_cmp will always return a positive value - this
>> is obviously bogus. u is smaller than v if and only if it is larger in
>> absolute value.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>  lib/mpi/mpi-cmp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
>> index 1871e7b61ca0..3801694240d8 100644
>> --- a/lib/mpi/mpi-cmp.c
>> +++ b/lib/mpi/mpi-cmp.c
>> @@ -57,7 +57,7 @@ int mpi_cmp(MPI u, MPI v)
>>       if (usize != vsize && !u->sign && !v->sign)
>>               return usize - vsize;
>>       if (usize != vsize && u->sign && v->sign)
>> -             return vsize + usize;
>> +             return vsize - usize;
>>       if (!usize)
>>               return 0;
>>       cmp = mpihelp_cmp(u->d, v->d, usize);
>> --
>> 2.1.3
>>
> _______________________________________________
> Keyrings mailing list
> Keyrings@linux-nfs.org
> To change your subscription to this list, please see http://linux-nfs.org/cgi-bin/mailman/listinfo/keyrings



-- 
Thanks,
Dmitry
