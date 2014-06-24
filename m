Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaFXKOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:14:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaFXKOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:14:38 -0400
Date: Tue, 24 Jun 2014 10:03:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] sched/idle: Drop !! while calculating 'broadcast'
Message-ID: <20140624080347.GL13930@laptop.programming.kicks-ass.net>
References: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:01:01AM +0530, Viresh Kumar wrote:
> We don't need 'broadcast' to be set to 'zero or one', but to 'zero or non-zero'
> and so the extra operation to convert it to 'zero or one' can be skipped.
> 
> Also change type of 'broadcast' to unsigned int, i.e. type of
> drv->states[*].flags.

All true; but does it change anything? That is, does your compiler
generate better code because of this?
