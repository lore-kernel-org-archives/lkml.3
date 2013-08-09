Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314Ab3HIDal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:30:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46980 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967452Ab3HIDaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:30:39 -0400
Message-ID: <1376019038.2087.50.camel@joe-AO722>
Subject: Re: [PATCH]arch:avr32:kernel:time.c: Removed IRQF_DISABLED
From: Joe Perches <joe@perches.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: hskinnemoen@gmail.com, egtvedt@samfundet.no, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Thu, 08 Aug 2013 20:30:38 -0700
In-Reply-To: <52045FB3.9060001@gmail.com>
References: <1376018243-8565-1-git-send-email-kumargauravgupta3@gmail.com>
	 <52045FB3.9060001@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 08:49 +0530, Kumar Gaurav wrote:
> Please ignore the below patch. I'll be resending this with 0 instead of 
> IRQF_TRIGGER_NONE

Hey again Kumar.

This is one of those patches that should just have
IRQF_DISABLED completely elided.

> On Friday 09 August 2013 08:47 AM, Kumar Gaurav wrote:
[]
> > diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
[]
> > @@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
[]
> > -	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
> > +	.flags		= IRQF_TIMER | IRQF_TRIGGER_NONE | IRQF_SHARED,

	.flags		= IRQF_TIMER | IRQF_SHARED,


