Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaIQQtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:49:10 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56616 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178AbaIQQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:49:05 -0400
Message-ID: <1410972543.31130.87.camel@x220>
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
From: Paul Bolle <pebolle@tiscali.nl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Clark Williams <clark.williams@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 18:49:03 +0200
In-Reply-To: <20140916204156.GP4723@linux.vnet.ibm.com>
References: <20140915100524.2cd80d2e@sluggy>
	 <20140916204156.GP4723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2014 16:49:03.0530 (UTC) FILETIME=[49B188A0:01CFD297]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, 2014-09-16 at 13:41 -0700, Paul E. McKenney wrote:
> rcu: unify boost and kthread priorities
> 
> Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> threads (rcub/n).
> 
> Also, create the module_parameter rcutree.kthread_prio to be used on
> the kernel command line at boot to set a new value (rcutree.kthread_prio=N).
> 
> Signed-off-by: Clark Williams <clark.williams@gmail.com>
> [ paulmck: Ported to rcu/dev. ]
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This landed in today's linux-next (ie, next-20140917) as commit
04a96e05bda6 ("rcu: unify boost and kthread priorities").

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>[...]
> diff --git a/init/Kconfig b/init/Kconfig
>[...]
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>[...]

There's a reference to CONFIG_RCU_BOOST_PRIO in
tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt. It needs
updating too, doesn't it?


Paul Bolle

