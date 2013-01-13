Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3AMSMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 13:12:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38562 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3AMSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 13:12:53 -0500
Date: Sun, 13 Jan 2013 10:12:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: paul.mckenney@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Build error on kernel/rcutree.c
Message-ID: <20130113181245.GK3384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAOMZO5ASEY6iHQ1UekR88vWZPutsJdiEuGkpsC2Civ6ezi2NGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ASEY6iHQ1UekR88vWZPutsJdiEuGkpsC2Civ6ezi2NGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011318-7282-0000-0000-000013195DB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 04:03:24PM -0200, Fabio Estevam wrote:
> Hi Paul,
> 
> When building ARM imx_v4_v5_defconfig the following error shows up on
> linux-next 20130111:
> 
> kernel/rcutree.c:808:2: error: implicit declaration of function
> 'rcu_jiffies_till_stall_check' [-Werror=implicit-function-declaration]
> kernel/rcutree.c:941:6: error: 'rcu_cpu_stall_suppress' undeclared
> (first use in this function)
> 
> Is this a known issue?

Yes, the fix is in -rcu and should make it to -next soon.

In the meantime, you can work around the problem by avoiding selecting
CONFIG_TREE_PREEMPT_RCU=y on SMP=n builds -- use CONFIG_TINY_PREEMPT_RCU
instead.

							Thanx, Paul

