Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKGLxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:53:20 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59422 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbaKGLxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:53:16 -0500
Message-ID: <1415361193.4390.46.camel@x220>
Subject: Re: [REGRESSION] in 3.18-rc1: ppp crashes kernel
From: Paul Bolle <pebolle@tiscali.nl>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 07 Nov 2014 12:53:13 +0100
In-Reply-To: <545CA8B6.2060608@message-id.googlemail.com>
References: <545CA8B6.2060608@message-id.googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2014 11:53:14.0281 (UTC) FILETIME=[69625190:01CFFA81]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 12:10 +0100, Stefan Seyfried wrote:
> I bisected the issue multiple times and always arrived at
> 
> # first bad commit: [d6dd50e07c5bec00db2005969b1a01f8ca3d25ef] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> 
> which is a merge commit unfortunately.

That merge commit actually does add some code:

git show d6dd50e07c5bec00db2005969b1a01f8ca3d25ef
[...]
diff --cc init/main.c
index 8af2f1abfe38,e3c4cdd94d5b..c5c11da6c4e1
--- a/init/main.c
+++ b/init/main.c
@@@ -583,6 -585,6 +583,7 @@@ asmlinkage __visible void __init start_
  	early_irq_init();
  	init_IRQ();
  	tick_init();
++	rcu_init_nohz();
  	init_timers();
  	hrtimers_init();
  	softirq_init();

Wild guess: is CONFIG_RCU_NOCB_CPU perhaps set in your
v3.18-rc3 .config?


Paul Bolle

