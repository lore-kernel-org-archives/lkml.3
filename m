Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966277Ab3HHTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:31:29 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:35853 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966243Ab3HHTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:31:28 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 15:31:28 EDT
Date: Thu, 8 Aug 2013 19:25:46 +0000
From: Christoph Lameter <cl@gentwo.org>
To: David Daney <ddaney.cavm@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] smp.c: Quit unconditionally enabling irqs in
 on_each_cpu_mask().
In-Reply-To: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com>
References: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.08-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013, David Daney wrote:

> I don't know of any bugs currently caused by this unconditional
> local_irq_enable(), but I want to use this function in MIPS/OCTEON
> early boot (when we have early_boot_irqs_disabled).  This also makes
> this function have similar semantics to on_each_cpu() which is good in
> itself.

smp_call_function_many() wants interrupts enabled.
