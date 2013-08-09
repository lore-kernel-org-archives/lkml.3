Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab3HIPDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:03:05 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59280 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064Ab3HIPDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:03:02 -0400
Date: Fri, 9 Aug 2013 11:02:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/2] workqueue: add new schedule_on_cpu_mask() API
Message-ID: <20130809150257.GM20515@mtj.dyndns.org>
References: <5202CEAA.9040204@linux.vnet.ibm.com>
 <201308072335.r77NZJPA022490@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308072335.r77NZJPA022490@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chris.

On Wed, Aug 07, 2013 at 04:49:44PM -0400, Chris Metcalf wrote:
> This primitive allows scheduling work to run on a particular set of
> cpus described by a "struct cpumask".  This can be useful, for example,
> if you have a per-cpu variable that requires code execution only if the
> per-cpu variable has a certain value (for example, is a non-empty list).

So, this allows scheduling work items on !online CPUs.  Workqueue does
allow scheduling per-cpu work items on offline CPUs if the CPU has
ever been online, but the behavior when scheduling work items on cpu
which has never been online is undefined.  I think the interface at
least needs to verify that the the target cpus have been online,
trigger warning and mask off invalid CPUs otherwise.

Thanks.

-- 
tejun
