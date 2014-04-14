Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaDNJQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:16:08 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51591 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaDNJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:16:06 -0400
Date: Mon, 14 Apr 2014 11:16:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86: initialize secondary CPU only if master CPU
 will wait for it
Message-ID: <20140414091600.GA19771@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
 <1397150061-29735-2-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397150061-29735-2-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

>  	/*
> +	 * wait for ACK from master CPU before continuing
> +	 * with AP initialization
> +	 */
> +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> +		cpu_relax();

> +	/*
> +	 * wait for ACK from master CPU before continuing
> +	 * with AP initialization
> +	 */
> +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> +		cpu_relax();

That repetitive pattern could be stuck into a properly named helper 
inline function.

(Also, before the cpumask_set_cpu() we should probably do a WARN_ON() 
if the bit is already set.)

Thanks,

	Ingo
