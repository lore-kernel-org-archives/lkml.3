Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaG3XHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:07:18 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:46526 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaG3XHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:07:16 -0400
Message-ID: <53D97A9E.3090908@twiddle.net>
Date: Wed, 30 Jul 2014 13:07:10 -1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
CC: linux-kernel@vger.kernel.org, mcree@orcon.net.nz,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: Remove "strange" OSF/1 fork semantics
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>	<1406756552-23864-2-git-send-email-rth@twiddle.net> <yw1xk36u5wrf.fsf@unicorn.mansr.com>
In-Reply-To: <yw1xk36u5wrf.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 12:04 PM, Måns Rullgård wrote:
> Richard Henderson <rth@twiddle.net> writes:
> 
>> The assignment to regs->r20 kills the original tls_val input
>> to the clone syscall, which means that clone can no longer be
>> restarted with the original inputs.
>>
>> We could, perhaps, retain this result for true fork, but OSF/1
>> compatibility is no longer important.  Note that glibc has never
>> used the r20 result value, instead always testing r0 vs 0 to
>> determine the child/parent status.
> 
> What effect does this have on OSF/1 compat?

I don't know, as I've never had access to osf/1 myself.  It depends on how that
$20 value is used -- potentially, fork(3) no longer works.

I can imagine that we could retain these assignments under the condition of
clone_flags == 0, which both implies a basic fork as well as the fact that the
tls_val argument is unused.

But I do have to ask first if anyone actually cares.  Surely the amount of
osf-on-linux emulation is a vanishingly small proportion of the already small
alpha-linux population.


r~
