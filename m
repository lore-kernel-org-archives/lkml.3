Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaGPWEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:04:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaGPWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:04:20 -0400
Date: Wed, 16 Jul 2014 15:08:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch V2 50/64] hangcheck-timer: Use ktime_get_ns()
Message-ID: <20140716220854.GA716@kroah.com>
References: <20140716205018.175419210@linutronix.de>
 <20140716205056.454252756@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716205056.454252756@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:05:03PM -0000, Thomas Gleixner wrote:
> There is no point in having a S390 private implementation and there is
> no point in using the raw monotonic time. The NTP freqeuency
> adjustment of CLOCK_MONOTONIC is really not doing any harm for the
> hang check timer.
> 
> Use ktime_get_ns() for everything and get rid of the timespec
> conversions.
> 
> V2: Drop the raw monotonic and the S390 special case
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
