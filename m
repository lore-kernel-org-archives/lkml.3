Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaJCMHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:07:49 -0400
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:34076 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaJCMHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:07:48 -0400
Date: Fri, 3 Oct 2014 07:07:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Richard Cochran <richardcochran@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <20141003120345.GA6652@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Richard Cochran wrote:

> >  DECLARE_PER_CPU(char *, irq_stack_ptr);
> > -DECLARE_PER_CPU(unsigned int, irq_count);
> > +DECLARE_PER_CPU(unsigned long, irq_count);
>
> Still 32 bit on 32 bit machines...

64 bit counters on 32 bit machines are not an easy thing and could be
expensive to handle in particular because these counters are used in
performance critical hotpaths.

I thought I better leave it alone on 32 bit.

