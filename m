Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3GSKFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:05:05 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:58415 "HELO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750784Ab3GSKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:05:02 -0400
Date: Fri, 19 Jul 2013 22:03:30 +1200
From: Michael Cree <cree@waikato.ac.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] Alpha support for QEMU
Message-ID: <20130719100330.GA20339@stolen.phys.waikato.ac.nz>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
 <20130718011435.GA20007@stolen.phys.waikato.ac.nz>
 <51E7EFC6.6070003@twiddle.net>
 <20130718212815.GA32459@stolen.phys.waikato.ac.nz>
 <51E86669.5040608@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E86669.5040608@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 03:04:25PM -0700, Richard Henderson wrote:
> On 07/18/2013 02:28 PM, Michael Cree wrote:
> > On the kernel without the patch set the dummy-RTC timer interrupt received
> > 30876 interrupts in a 30s period which is within measurement uncertainty of
> > the expected 30*1024 = 30720 interrupts.
> > 
> > On the kernel with the patch set the dummy-RTC timer interrupt received 14419 
> > interrupts on CPU-1, 13935 interrupts on CPU-2 and 2619 interrupts on CPU-3
> > over a 30s period.
> 
> Grr.  Naturally, the old kernel obfuscates which timers are being delivered
> where.  So a direct comparison doesn't appear possible.  But those separated
> numbers seem uncomfortably low.
> 
> I've just pushed a new branch to
> 
>   git://github.com/rth7680/linux.git axp-qemu-7
> 
> Please try that with CONFIG_ALPHA_WTINT disabled.  I'd like to eliminate that
> as a source of uncertainty for your system.

Running that axp-qemu-7 branch with RTC_DRV_ALPHA on and ALPHA_WTINT off
still results in a rather slow clock.  (Does start up with correct time
now that I have RTC_DRV_ALPHA selected.)

Over a 30s period still get too few timer interrupts: 843, 28805 and 1434
interrupts on the CPUs.

Cheers
Michael
