Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3C0G7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:59:55 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.69]:52683 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3C0G7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:59:53 -0400
Date: Wed, 27 Mar 2013 19:59:48 +1300
From: Michael Cree <mcree@orcon.net.nz>
To: Shuah Khan <shuah.khan@hp.com>
Cc: rth@twiddle.net, m.szyprowski@samsung.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, kyungmin.park@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, linux-alpha@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH RFT linux-next] alpha: dma-mapping: support
 debug_dma_mapping_error
Message-ID: <20130327065948.GO5042@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	Shuah Khan <shuah.khan@hp.com>, rth@twiddle.net,
	m.szyprowski@samsung.com, ink@jurassic.park.msu.ru,
	mattst88@gmail.com, kyungmin.park@samsung.com, arnd@arndb.de,
	andrzej.p@samsung.com, linux-alpha@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
References: <1351269163.4013.27.camel@lorien2>
 <1353001768.2532.31.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353001768.2532.31.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Check: by mx9.orcon.net.nz on Wed, 27 Mar 2013 19:59:49 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 27 19:59:51 2013
X-DSPAM-Confidence: 0.9925
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06Jgv67kj - a8ebfab44830 - 20130327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 10:49:28AM -0700, Shuah Khan wrote:
> On Fri, 2012-10-26 at 10:32 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  arch/alpha/include/asm/dma-mapping.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> > index dfa32f0..b4d483b 100644
> > --- a/arch/alpha/include/asm/dma-mapping.h
> > +++ b/arch/alpha/include/asm/dma-mapping.h
> > @@ -32,6 +32,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
> >  
> >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >  {
> > +	debug_dma_mapping_error(dev, dma_addr);
> >  	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
> >  }
> >  
> 
> Marek,
> 
> This is for alpha to go through your tree.

Given that this does not appear to be upstream yet I'll take it through
the Alpha tree.

Cheers
Michael.

