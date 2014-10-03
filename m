Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJCMPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:15:17 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51407 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbaJCMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:15:14 -0400
Message-ID: <1412338512.19413.85.camel@x220>
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 14:15:12 +0200
In-Reply-To: <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
	 <alpine.DEB.2.11.1410031231420.4383@nanos>
	 <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2014 12:15:12.0561 (UTC) FILETIME=[AEAEA210:01CFDF03]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 06:54 -0500, Christoph Lameter wrote:
> On Fri, 3 Oct 2014, Thomas Gleixner wrote:
> 
> > > Is this the way its intended or should the counters be expanded to 64 bit?
> >
> > There is no reason why we cannot or should not expand them.
> 
> Ok here is a patch to do just that:
> 
> 
> Subject: Increase irq counters to 64 bit
> 
> 
> Irq counters can overflow easily if they are just 32 bit.
> 
> For example the timer interrupt occurs 1000 times per second, so
> it is predictable that the timer interrupt will overflow in
> 
> 
> 2^ 32 / 1000 [interrupts per second] / 86400 [seconds in a day]
> 
> which results in 46 days.

dc -e "1 k 2 32 ^ 1000 / 86400 / p"
49.7

(That was the number I remembered from stories about a ancient Windows
lockup.)

> Other irq counters for devices may wrap even faster for example
> those for high speed networking devices.
> 
> This patch is needed to avoid the counter overflow by increasing
> the counters to 64 bit.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>


Paul Bolle


