Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3IER2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:28:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49636 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab3IER2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:28:35 -0400
Date: Thu, 5 Sep 2013 18:28:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130905172810.GB29219@mudshark.cambridge.arm.com>
References: <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
 <20130904142324.GD3643@mudshark.cambridge.arm.com>
 <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com>
 <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
 <20130904182113.GD5599@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1309041324530.26497@gentwo.org>
 <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
 <20130905130359.GA22351@mudshark.cambridge.arm.com>
 <00000140ee828138-3328099b-149e-433d-8262-0a481806ca85-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ee828138-3328099b-149e-433d-8262-0a481806ca85-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:24:25PM +0100, Christoph Lameter wrote:
> On Thu, 5 Sep 2013, Will Deacon wrote:
> 
> > >
> > >  	if (el == DBG_ACTIVE_EL1 &&
> > > -	    local_dec_and_test(this_cpu_ptr(&kde_ref_count)))
> > > +	    this_cpu_dec_return(kde_ref_count))
> > >  		disable &= ~DBG_MDSCR_KDE;
> >
> > Almost! I think we just need an '== 0' check on the result from the
> > decrement, since local_dec_and_test is simply a way to check that we've
> > decremented to zero, so this patch would otherwise invert the meaning.
> 
> Ok can you take it from here and modify it? I have no build and test
> environment set up for ARM.

Sure. Does that include the original arm/arm64 patches from your v3 series
as well as these two fixups?

Will
