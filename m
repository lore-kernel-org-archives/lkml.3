Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaE0UfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:35:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58427 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbaE0Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:34:58 -0400
Date: Tue, 27 May 2014 21:34:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140527203427.GC31850@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1401054470.3958.30.camel@pasglop>
 <20140527193425.GC30751@arm.com>
 <1401222210.20915.79.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401222210.20915.79.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:23:30PM +0100, Benjamin Herrenschmidt wrote:
> On Tue, 2014-05-27 at 20:34 +0100, Will Deacon wrote:
> 
> > Do you mean the io{read,write} functions? Funnily enough, they're already
> > relaxed on ARM if you go by the semantics I've proposed. That implies we at
> > least need some Documentation to that effect...
> > 
> > What do you do on ppc?
> 
> They are not supposed to be relaxed. If they are, you probably have a
> whole lot of busted drivers :-)

Lucky me!

> They have the same semantics as readl/writel for memory and as inb/outb
> for IO space, they just allow to hide the "type" (memory vs. IO) from
> most of the driver code.
> 
> We probably need to create a set of _relaxed variants.

Ok. I'll try putting together a v3 including this and the mmiowb work.

Thanks for the feedback,

Will
