Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3GAVIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:08:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44045 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:08:37 -0400
Date: Mon, 01 Jul 2013 14:08:33 -0700 (PDT)
Message-Id: <20130701.140833.1705666564717621661.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, willemb@google.com,
        erdnetdev@gmail.com, andi@firstfloor.org, hpa@zytor.com,
        devel-lists@codyps.com, eliezer@tamir.org.il
Subject: Re: [PATCH net-next 0/2] net: lls cleanup patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>
References: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Fri, 28 Jun 2013 15:59:18 +0300

> Here are two cleanup patches.
> 
> 1. fix warning from debug_smp_processor_id().
> - reported by Cody P Schafer.
> 
> 2. avoid calling sched_clock() in select and poll when lls is disabled.
> - reported by Andi Kleen.
> 
> Thanks to everyone for their comments.

Applied, but like Ben said perhaps you want to remember the last cpu you
got the sched_clock() measurement from and abort the ll poll if it changes
on you instead of using a comparison between two cpus.

But then again, since preemption is enabled, the cpu could change
back and forth during the sched_clock() call, so you wouldn't be able
to reliably detect this anyways.

In the grand scheme of things all of this probably doesn't matter at
all.
