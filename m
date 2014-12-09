Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaLIUKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:10:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:50004 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaLIUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:10:44 -0500
Date: Tue, 9 Dec 2014 21:10:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] smpboot: Check for successfull allocation of cpumask
 vars
In-Reply-To: <1418140999-29092-1-git-send-email-bobby.prani@gmail.com>
Message-ID: <alpine.DEB.2.11.1412092103270.16275@nanos>
References: <1418140999-29092-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Pranith Kumar wrote:
> zalloc_cpumask_var() can return 0 on allocation failure when
> CONFIG_CPUMASK_OFFSTACK is set. Check for the return value and WARN() on failure
> of an allocation in such cases.

And that warning helps in which way?

It just prints a completely useless backtrace and breaks out of the
loop, but it does not prevent that later on code will trip over the
non allocated per cpu data.

Thanks,

	tglx
