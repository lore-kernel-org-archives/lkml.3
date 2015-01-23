Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbbAWRy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:54:56 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:49011 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbAWRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:54:52 -0500
Date: Fri, 23 Jan 2015 17:54:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: arm64 -- psci tell the compiler in which registers we are
 expecting arguments
Message-ID: <20150123175445.GF26493@n2100.arm.linux.org.uk>
References: <1422034314-27084-1-git-send-email-apw@canonical.com>
 <20150123175039.GC13772@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123175039.GC13772@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:50:39PM +0000, Will Deacon wrote:
> On Fri, Jan 23, 2015 at 05:31:54PM +0000, Andy Whitcroft wrote:
> > diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
> > index f1dbca7..425cf78 100644
> > --- a/arch/arm64/kernel/psci.c
> > +++ b/arch/arm64/kernel/psci.c
> > @@ -113,9 +113,14 @@ static void psci_power_state_unpack(u32 power_state,
> >   * The following two functions are invoked via the invoke_psci_fn pointer
> >   * and will not be inlined, allowing us to piggyback on the AAPCS.
> >   */
> > -static noinline int __invoke_psci_fn_hvc(u64 function_id, u64 arg0, u64 arg1,
> > -					 u64 arg2)
> > +static noinline int __invoke_psci_fn_hvc(u64 _function_id, u64 _arg0,
> > +					 u64 _arg1, u64 _arg2)
> >  {
> > +	register u64 function_id asm("x0") = _function_id;
> > +	register u64 arg0 asm("x1") = _arg0;
> > +	register u64 arg1 asm("x2") = _arg1;
> > +	register u64 arg2 asm("x3") = _arg2;
> > +
> 
> Given that we've already been bitten by the compiler, I think we should
> just bite the bullet and implement these two functions in assembly in a
> separate file rather than rely on register variables doing what we want.

The alternative is a naked function.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
