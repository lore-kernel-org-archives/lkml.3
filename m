Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaFXMSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:18:09 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63206 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFXMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:18:07 -0400
Message-ID: <1403612280.29711.115.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/idle: Drop !! while calculating 'broadcast'
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Tue, 24 Jun 2014 14:18:00 +0200
In-Reply-To: <20140624080347.GL13930@laptop.programming.kicks-ass.net>
References: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
	 <20140624080347.GL13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 10:03 +0200, Peter Zijlstra wrote: 
> On Tue, Jun 24, 2014 at 10:01:01AM +0530, Viresh Kumar wrote:
> > We don't need 'broadcast' to be set to 'zero or one', but to 'zero or non-zero'
> > and so the extra operation to convert it to 'zero or one' can be skipped.
> > 
> > Also change type of 'broadcast' to unsigned int, i.e. type of
> > drv->states[*].flags.
> 
> All true; but does it change anything? That is, does your compiler
> generate better code because of this?

x86_64 gcc-4.8.3 made 1 less instruction, a shift.

-Mike

