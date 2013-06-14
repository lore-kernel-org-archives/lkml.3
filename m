Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3FNM2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:28:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56195 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3FNM2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:28:07 -0400
Date: Fri, 14 Jun 2013 05:28:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rojhalat Ibrahim <imr@rtschenk.de>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130614122800.GL5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1626500.7WAVXjfS9F@pcimr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626500.7WAVXjfS9F@pcimr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061412-5806-0000-0000-000021B5AB05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 01:47:00PM +0200, Rojhalat Ibrahim wrote:
> Hi,
> 
> the current mainline kernel from git reproducibly hangs on my Freescale 
> PowerPC P5020DS development system. Most of the time the hang occurs during 
> boot (kernel just stops booting, system hangs), sometimes shortly after 
> booting (system hangs, no message). Very often booting stops at the 
> initialization of the Intel PRO 1000 PCIe network device (e1000e).
> 
> I used git bisect and arrived at this commit:
> 
> 016a8d5be6ddcc72ef0432d82d9f6fa34f61b907
> rcu: Don't call wakeup() with rcu_node structure ->lock held
> 
> With versions before that commit the system runs normally.

Odd, given that this fix was intended to prevent hangs.  Could you
please send your .config?

							Thanx, Paul

