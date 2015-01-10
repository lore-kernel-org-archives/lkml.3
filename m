Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbbAJKeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:34:36 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48971 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbbAJKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <2258.1420801223@warthog.procyon.org.uk>
References: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417824042-539-2-git-send-email-linux@rasmusvillemoes.dk>
	<2258.1420801223@warthog.procyon.org.uk>
Date: Sat, 10 Jan 2015 12:29:21 +0200
Message-ID: <CACE9dm8N31zAdxC5J0N=dCAqRMA25k8cnTK25NqvaE=tOAWs0A@mail.gmail.com>
Subject: Re: [Keyrings] [PATCH 2/2] MPILIB: Deobfuscate mpi_cmp
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        keyrings <keyrings@linux-nfs.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you. Indeed '-cmp' is much more clear.

Ack.

- Dmitry

On 9 January 2015 at 13:00, David Howells <dhowells@redhat.com> wrote:
> This looks very reasonable.  cc'ing Dmitry for his check.
>
> David
> ---
> Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> The condition preceding 'return 1;' makes my head hurt. At this point,
>> we know that u and v have the same sign; if they are negative, they
>> compare opposite to how their absolute values compare (which
>> mpihelp_cmp found for us), otherwise cmp itself is the
>> answer. Negating cmp is ok since mpihelp_cmp returns {-1,0,1};
>> -INT_MIN==INT_MIN won't bite us.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>  lib/mpi/mpi-cmp.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
>> index 3801694240d8..d25e9e96c310 100644
>> --- a/lib/mpi/mpi-cmp.c
>> +++ b/lib/mpi/mpi-cmp.c
>> @@ -61,10 +61,8 @@ int mpi_cmp(MPI u, MPI v)
>>       if (!usize)
>>               return 0;
>>       cmp = mpihelp_cmp(u->d, v->d, usize);
>> -     if (!cmp)
>> -             return 0;
>> -     if ((cmp < 0 ? 1 : 0) == (u->sign ? 1 : 0))
>> -             return 1;
>> -     return -1;
>> +     if (u->sign)
>> +             return -cmp;
>> +     return cmp;
>>  }
>>  EXPORT_SYMBOL_GPL(mpi_cmp);
>> --
>> 2.1.3
> _______________________________________________
> Keyrings mailing list
> Keyrings@linux-nfs.org
> To change your subscription to this list, please see http://linux-nfs.org/cgi-bin/mailman/listinfo/keyrings



-- 
Thanks,
Dmitry
