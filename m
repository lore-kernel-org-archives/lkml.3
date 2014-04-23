Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaDWHiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:38:08 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46999 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbaDWHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:38:05 -0400
Date: Wed, 23 Apr 2014 09:37:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, schwidefsky@de.ibm.com,
        paulmck@linux.vnet.ibm.com, gang.chen@asianux.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Cc: tipbot@zytor.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:locking/core] arch,s390: Convert smp_mb__*()
Message-ID: <20140423093757.2c07c209@mschwide>
In-Reply-To: <tip-kme5dz5hcobpnufnnkh1ech2@git.kernel.org>
References: <tip-kme5dz5hcobpnufnnkh1ech2@git.kernel.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042307-8372-0000-0000-0000096EB445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 18 Apr 2014 06:11:38 -0700
tip-bot for Peter Zijlstra <tipbot@zytor.com> wrote:

> arch,s390: Convert smp_mb__*()
> 
> As per the existing implementation; implement the new one using
> smp_mb().
> 
> AFAICT the s390 compare-and-swap does imply a barrier, however there
> are some immediate ops that seem to be singly-copy atomic and do not
> imply a barrier. One such is the "ni" op (which would be
> and-immediate) which is used for the constant clear_bit
> implementation. Therefore s390 needs full barriers for the
> {before,after} atomic ops.

Good catch, if ni/oi are used this is required. What we want to
add is an #ifdef CONFIG_HAVE_MARCH_Z196_FEATURES. With smp_mb__*
defined as smp_mb() we get additional barriers for older machines
while the atomic ops are defined with compare-and-swap which
already does the barrier before and after the operation.

We can do that with a patch on top of this one, so no hurry.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

