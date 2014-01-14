Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaANQvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:51:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38737 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaANQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:51:29 -0500
Date: Tue, 14 Jan 2014 17:51:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3/11] issue 3: No understanding of potential cpu capacity
Message-ID: <20140114165119.GJ7572@laptop.programming.kicks-ass.net>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
 <3700155.hLuCBAXQoy@vostro.rjw.lan>
 <20140114163953.GF3000@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114163953.GF3000@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:39:54PM +0000, Morten Rasmussen wrote:
> Responsiveness is still very important. It is quite hard to control. CFS
> doesn't consider latency. The only way to get the best responsiveness is
> to go for best performance which comes at a high cost in energy.

The big problem is that the normal unix task model doesn't cover his at
all -- nice isn't much of a knob.

There's ways in which you can adapt CFS to include such a measure
(search for the EEVDF patches), but I was kinda hoping that tasks that
really desire responsiveness could be made to use SCHED_DEADLINE or
such.


