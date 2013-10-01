Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3JAIgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:36:22 -0400
Received: from ozlabs.org ([203.10.76.45]:35695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3JAIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:36:19 -0400
Date: Tue, 1 Oct 2013 18:36:15 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, herbert@gondor.hengli.com.au,
        gleb@redhat.com, agraf@suse.de, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, mpm@selenic.com, pbonzini@redhat.com
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131001083615.GC27484@concordia>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
 <52459311.4010104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52459311.4010104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 07:45:45PM +0530, Anshuman Khandual wrote:
> On 09/26/2013 12:01 PM, Michael Ellerman wrote:
> > +int powernv_hwrng_present(void)
> > +{
> > +	return __raw_get_cpu_var(powernv_rng) != NULL;
> > +}
> > +
> >  static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
> >  {
> >  	unsigned long parity;
> > @@ -42,6 +48,17 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
> >  	return val;
> >  }
> > 
> > +int powernv_get_random_real_mode(unsigned long *v)
> > +{
> > +	struct powernv_rng *rng;
> > +
> > +	rng = __raw_get_cpu_var(powernv_rng);
> > +
> > +	*v = rng_whiten(rng, in_rm64(rng->regs_real));
> > +
> 
> Will it be in_be64() instead of in_rm64() ? Its failing the build here. Except this
> all individual patches build correctly.

No it's definitely not in_be64() - that will checkstop your machine :)

I added in_rm64() in a previous patch, "Add real mode cache inhibited
IO accessors" - I just didn't want to spam the KVM guys with those
patches as well.

Thanks for the review & testing.

cheers
