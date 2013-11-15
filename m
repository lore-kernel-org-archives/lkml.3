Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab3KOLGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:06:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:38861 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3KOLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:06:38 -0500
Date: Fri, 15 Nov 2013 12:06:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lan Tianyu <tianyu.lan@intel.com>
cc: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        rjw@rjwysocki.net, viresh.kumar@linaro.org, rostedt@goodmis.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] Tick: Introduce tick_nohz_check() to check nohz
 enable status
In-Reply-To: <1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
Message-ID: <alpine.DEB.2.02.1311151200560.30673@ionos.tec.linutronix.de>
References: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com> <1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Lan Tianyu wrote:

> In some cases, nohz enable status needs to be checked. E.G, in RCU and cpufreq
> ondemand governor. So add tick_nohz_check() to return tick_nohz_enabled value
> And use tick_nohz_check() instead of referencing tick_nohz_enabled in the rcutree_plugin.h.

What's the point of this? 

Checking for tick_nohz_enabled is wrong to begin with.

See https://lkml.org/lkml/2013/11/13/424
