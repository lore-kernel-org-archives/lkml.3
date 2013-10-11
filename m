Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3JKKkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:40:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48205 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab3JKKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:40:18 -0400
Date: Fri, 11 Oct 2013 11:40:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: calibrate: don't print out bogomips value on boot
Message-ID: <20131011104014.GC14732@mudshark.cambridge.arm.com>
References: <1381330640-32735-1-git-send-email-will.deacon@arm.com>
 <20131010145235.1c6574299bc636cf92190d32@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010145235.1c6574299bc636cf92190d32@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:52:35PM +0100, Andrew Morton wrote:
> On Wed,  9 Oct 2013 15:57:20 +0100 Will Deacon <will.deacon@arm.com> wrote:
> 
> > @@ -295,9 +295,7 @@ void calibrate_delay(void)
> >  	}
> >  	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
> >  	if (!printed)
> > -		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
> > -			lpj/(500000/HZ),
> > -			(lpj/(5000/HZ)) % 100, lpj);
> > +		pr_cont("lpj=%lu\n", lpj);
> >  
> >  	loops_per_jiffy = lpj;
> >  	printed = true;
> 
> Kidding?  BogoMIPS is an industry-standard metric which was established
> before many of us were born.  It even has its own wikipedia page!

Crikey, have you looked at that page? ARM is ominously described as `not
enough data (yet)' when discussing its BogoMIPS `rating'. This is all more
food for the marketing machines :(

> You have no heart.

Maybe I should stop worrying and learn to love the BogoMIPS.

Will
