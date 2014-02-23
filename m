Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaBWUfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:35:44 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33784 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbaBWUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:35:43 -0500
Message-ID: <530A5B93.7010304@hurleysoftware.com>
Date: Sun, 23 Feb 2014 15:35:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
 use PREPARE_DELAYED_WORK)
References: <53074BE4.1020307@hurleysoftware.com> <20140221130614.GH6897@htj.dyndns.org> <5307849A.9050209@hurleysoftware.com> <20140221165730.GA10929@htj.dyndns.org> <5307DAC9.2020103@hurleysoftware.com> <1393094608.11497.1.camel@dabdike.int.hansenpartnership.com> <5308F0E2.3030804@hurleysoftware.com> <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com> <5308F48C.8080609@hurleysoftware.com> <20140223022303.3240093c@stein> <20140223163743.GU4250@linux.vnet.ibm.com>
In-Reply-To: <20140223163743.GU4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 02/23/2014 11:37 AM, Paul E. McKenney wrote:
> commit aba6b0e82c9de53eb032844f1932599f148ff68d
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Sun Feb 23 08:34:24 2014 -0800
>
>      Documentation/memory-barriers.txt: Clarify release/acquire ordering
>
>      This commit fixes a couple of typos and clarifies what happens when
>      the CPU chooses to execute a later lock acquisition before a prior
>      lock release, in particular, why deadlock is avoided.
>
>      Reported-by: Peter Hurley <peter@hurleysoftware.com>
>      Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>      Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>      Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 9dde54c55b24..c8932e06edf1 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1674,12 +1674,12 @@ for each construct.  These operations all imply certain barriers:
>        Memory operations issued after the ACQUIRE will be completed after the
>        ACQUIRE operation has completed.
>
> -     Memory operations issued before the ACQUIRE may be completed after the
> -     ACQUIRE operation has completed.  An smp_mb__before_spinlock(), combined
> -     with a following ACQUIRE, orders prior loads against subsequent stores and
> -     stores and prior stores against subsequent stores.  Note that this is
> -     weaker than smp_mb()!  The smp_mb__before_spinlock() primitive is free on
> -     many architectures.
> +     Memory operations issued before the ACQUIRE may be completed after
> +     the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
> +     combined with a following ACQUIRE, orders prior loads against
> +     subsequent loads and stores and also orders prior stores against
> +     subsequent stores.  Note that this is weaker than smp_mb()!  The
> +     smp_mb__before_spinlock() primitive is free on many architectures.
>
>    (2) RELEASE operation implication:
>
> @@ -1717,23 +1717,47 @@ the two accesses can themselves then cross:
>
>   	*A = a;
>   	ACQUIRE M
> -	RELEASE M
> +	RELEASE N
>   	*B = b;
>
>   may occur as:
>
> -	ACQUIRE M, STORE *B, STORE *A, RELEASE M

This example should remain as is; it refers to the porosity of a critical
section to loads and stores occurring outside that critical section, and
importantly that LOCK + UNLOCK is not a full barrier. It documents that
memory operations from either side of the critical section may cross
(in the absence of other specific memory barriers). IOW, it is the example
to implication #1 above.

Regards,
Peter Hurley

