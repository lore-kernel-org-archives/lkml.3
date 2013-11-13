Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab3KMRLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:11:24 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:39837 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab3KMRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:11:17 -0500
Message-ID: <1384362668.3392.41.camel@linaro1.home>
Subject: Re: [PATCH v2 08/13] ARM: use a function table for determining
 instruction interpreter actions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 13 Nov 2013 17:11:08 +0000
In-Reply-To: <1381871068-27660-9-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
	 <1381871068-27660-9-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> When interpreting instructions use a client-supplied array of functions
> to take action.  This array can then be provided by krpobes, uprobes, or

'to take action' sounds a bit weird to me, how about 'to specify
actions'?

> possibly some other client subsystem.  The interpreter assigns a group
> number to each recognized instruction and invokes the corresponding action
> function.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/kernel/Makefile         |    2 +-
>  arch/arm/kernel/kprobes-arm.c    |   41 ++
>  arch/arm/kernel/kprobes-common.c |    3 +-
>  arch/arm/kernel/kprobes-thumb.c  | 1016 ++++----------------------------------
>  arch/arm/kernel/kprobes.c        |   10 +-
>  arch/arm/kernel/kprobes.h        |   14 +-
>  arch/arm/kernel/probes-arm.c     |  114 ++---
>  arch/arm/kernel/probes-arm.h     |   37 ++
>  arch/arm/kernel/probes-thumb.c   |  875 ++++++++++++++++++++++++++++++++
>  arch/arm/kernel/probes-thumb.h   |  136 +++++
>  arch/arm/kernel/probes.c         |    9 +-
>  arch/arm/kernel/probes.h         |   15 +-
>  12 files changed, 1288 insertions(+), 984 deletions(-)
>  create mode 100644 arch/arm/kernel/probes-thumb.c
>  create mode 100644 arch/arm/kernel/probes-thumb.h

As I mentioned in comments to patch 7, this patch seems to accidentally
include the thumb code reorg of moving code from kprobes-thumb.c to
probes-thumb.c

I've no other comments on the patch so trimmed the rest...

-- 
Tixy


