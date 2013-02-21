Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3BUV7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:59:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47969 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3BUV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:59:13 -0500
Date: Thu, 21 Feb 2013 21:58:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 2/5] kernel_cpustat: convert to atomic 64-bit
	accessors
Message-ID: <20130221215850.GC17833@n2100.arm.linux.org.uk>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org> <1361389302-11968-3-git-send-email-khilman@linaro.org> <87y5ehmp8d.fsf@linaro.org> <CAFTL4hw1=mKtUadL0WDrydtspOehKuW7jhhzr65vXR2P2zdTWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw1=mKtUadL0WDrydtspOehKuW7jhhzr65vXR2P2zdTWw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:53:07PM +0100, Frederic Weisbecker wrote:
> That too should be kcpustat_this_cpu_set(), or kcpustat_this_cpu_add()
> FWIW. But we probably don't need the overhead of atomic_add() that
> does a LOCK.
> atomic_set(var, atomic_read(var) + delta) would be better. All we need

You mean atomic64_set() and atomic64_read().  Looking at the generic
version in lib/atomic64.c, atomic64_add() is cheaper for 32-bit arches
because it doesn't involve taking the lock twice.
