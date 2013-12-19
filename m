Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3LSSFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:05:41 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58610 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3LSSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
Date: Thu, 19 Dec 2013 10:05:39 -0800
Message-ID: <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before CPU
 down [v2]
From: Tony Luck <tony.luck@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:50 AM, Tony Luck <tony.luck@intel.com> wrote:
> Looks good to me.

Though now I've been confused by an offline question about affinity.

Suppose we have some interrupt that has affinity to multiple cpus. E.g.
(real example from one of my machines):

# cat /proc/irq/94/smp_affinity_list
26,54

Now If I want to take either cpu26 or cpu54 offline - I'm guessing that I don't
really need to find a new home for vector 94 - because the other one of that
pair already has that set up.  But your check_vectors code doesn't look like
it accounts for that - if we take cpu26 offline - it would see that
cpu54 doesn't
have 94 free - but doesn't check that it is for the same interrupt.

But I may be mixing "vectors" and "irqs" here.

-Tony
