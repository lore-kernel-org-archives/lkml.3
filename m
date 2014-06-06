Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaFFMir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:38:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53695 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFFMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:38:45 -0400
Message-ID: <5391B5FE.2090508@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 18:07:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: ego@linux.vnet.ibm.com, matt@ozlabs.org, mahesh@linux.vnet.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        suzuki@in.ibm.com, ebiederm@xmission.com, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Vivek Goyal <vgoyal@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com> <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com> <1401833365.3247.36.camel@pasglop> <5391B413.100@linux.vnet.ibm.com>
In-Reply-To: <5391B413.100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060612-5140-0000-0000-00000541DA40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 05:59 PM, Srivatsa S. Bhat wrote:
 
> +bool kexec_cpu_wake(void)
> +{
> +	kexec_smp_down(NULL);
> +
> +	/* NOTREACHED */
> +	return true;
> +}
> +

This function doesn't have to return anything, so we can define it as void.
The bool is a remnant of my previous attempt at making this work. (But these
patches compile fine as they are, though).

Regards,
Srivatsa S. Bhat

