Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3CGHUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:20:31 -0500
Received: from smtp.citrix.com ([66.165.176.89]:53281 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3CGHUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:20:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,800,1355097600"; 
   d="scan'208";a="11707275"
Message-ID: <1362640662.8941.141.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
From: Ian Campbell <ian.campbell@citrix.com>
To: Will Deacon <will.deacon@arm.com>
CC: Rob Herring <robherring2@gmail.com>,
        "xen-devel@listsxen.org" <xen-devel@lists.xen.org>,
        "Keir (Xen.org)" <keir@xen.org>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Date: Thu, 7 Mar 2013 07:17:42 +0000
In-Reply-To: <20130307031707.GA25137@mudshark.cambridge.arm.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
	 <51340ACD.70904@gmail.com>
	 <20130305030436.GA18040@mudshark.cambridge.arm.com>
	 <513596F2.1000701@gmail.com>
	 <20130305080845.GA19097@mudshark.cambridge.arm.com>
	 <1362475797.8941.67.camel@hastur.hellion.org.uk>
	 <20130307031707.GA25137@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 03:17 +0000, Will Deacon wrote:
> > I looked and couldn't see an existing 64 bit xchg, was I looking in the
> > wrong place? Ah, wait, I see atomic64_xchg now. But that needs an
> > atomic64_t while I have a xen_ulong_t (which == 64 bits on ARM). This is
> > a kernel<->hypervisor ABI so I can't just change it to an atomic64_t. I
> > suppose I could cast (see below, untested) but that seems rather icky.
> 
> You can play some container_of tricks, like we do in cmpxchg64 to get this
> right. Alternatively, we could look at an xchg8 implementation which some
> other architectures have (although they seem to be 64-bit machines).

I went with the container of trick + appropriate Kconfig depends and
sent a patch out a couple of seconds ago.

Thanks for your help/advice!

Ian.

