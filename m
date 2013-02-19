Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3BSQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:34:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60180 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3BSQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:34:16 -0500
Message-ID: <5123A984.4000704@numascale-asia.com>
Date: Wed, 20 Feb 2013 00:34:12 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
CC: Steffen Persvold <sp@numascale.com>, LKML <linux-kernel@vger.kernel.org>
Subject: False-positive RCU stall warnings on large systems...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On some of our larger servers with many hundreds of cores and when under 
high duress, we can see scheduler RCU stall warnings [1], so find we 
have to increase the hardcoded RCU_STALL_RAT_DELAY up from 2 and 
RCU_JIFFIES_TILL_FORCE_QS up from 3.

Is there a more sustainable way to account for this to avoid it being 
hard-coded, such as making it and dependent timeouts a fraction of 
CONFIG_RCU_CPU_STALL_TIMEOUT?

On the other hand, perhaps this is just caused by clock jitter (eg due 
to distance from a contended clock source)? So increasing these a bit 
may just be adequate in general...

Many thanks,
   Daniel

--- [1]

[ 3939.010085] INFO: rcu_sched detected stalls on CPUs/tasks: {} 
(detected by 1, t=29662 jiffies, g=3053, c=3052, q=598)
[ 3939.020008] INFO: Stall ended before state dump start
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
