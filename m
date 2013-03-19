Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3CSPFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:05:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3CSPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:05:48 -0400
Message-ID: <1363705546.22553.61.camel@laptop>
Subject: Re: [PATCH 7/8] sched: prevent to re-select dst-cpu in
 load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 16:05:46 +0100
In-Reply-To: <1360820921-2513-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-8-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> But, in that, there is no code for preventing to re-select dst-cpu.
> So, same dst-cpu can be selected over and over.
> 
> This patch add functionality to load_balance() in order to exclude
> cpu which is selected once.

Oh man.. seriously? Did you see this happen? Also, can't we simply
remove it from lb->cpus?

