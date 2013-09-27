Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3I0ORA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:17:00 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58100 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3I0OQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:16:58 -0400
Message-ID: <52459311.4010104@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 19:45:45 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, tytso@mit.edu, herbert@gondor.hengli.com.au,
        gleb@redhat.com, agraf@suse.de, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, mpm@selenic.com, pbonzini@redhat.com
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
In-Reply-To: <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092714-2000-0000-0000-00000DE403E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:01 PM, Michael Ellerman wrote:
> +int powernv_hwrng_present(void)
> +{
> +	return __raw_get_cpu_var(powernv_rng) != NULL;
> +}
> +
>  static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
>  {
>  	unsigned long parity;
> @@ -42,6 +48,17 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
>  	return val;
>  }
> 
> +int powernv_get_random_real_mode(unsigned long *v)
> +{
> +	struct powernv_rng *rng;
> +
> +	rng = __raw_get_cpu_var(powernv_rng);
> +
> +	*v = rng_whiten(rng, in_rm64(rng->regs_real));
> +

Will it be in_be64() instead of in_rm64() ? Its failing the build here. Except this
all individual patches build correctly.

Regards
Anshuman

