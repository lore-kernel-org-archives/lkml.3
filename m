Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaEWO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:58:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47622 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbaEWO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:58:42 -0400
Date: Fri, 23 May 2014 15:57:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140523145758.GG21319@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1400777250-17335-17-git-send-email-will.deacon@arm.com>
 <537E30AF.4070501@zytor.com>
 <20140523144604.GF21319@arm.com>
 <537F60E0.1060307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537F60E0.1060307@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:53:20PM +0100, H. Peter Anvin wrote:
> On 05/23/2014 07:46 AM, Will Deacon wrote:
> > 
> > I would like the relaxed accessors to be ordered with respect to each other...
> > 
> > What do you think?
> > 
> 
> I think "I would like" isn't a very good motivation.  What are the
> semantics of these things supposed to be?  It seems more than a bit odd
> to require them to be ordered with respect to each other and everything
> else (which is what a memory clobber does) and then call them "relaxed".

I suggested some informal semantics in the cover letter:

  https://lkml.org/lkml/2014/4/17/269

Basically, if we define relaxed accesses not to be ordered against anything
apart from other accesses (relaxed or otherwise) to the same device, then
they become a tonne cheaper on arm/arm64/powerpc. Currently we have to
include expensive memory barriers in order to synchronise with accesses to
DMA buffers which is rarely needed.

For those requirements, I don't think we need the "memory" clobber for x86,
but would appreciate your views on this.

Will
