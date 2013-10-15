Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab3JORFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:05:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42369 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902Ab3JORFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:05:05 -0400
Date: Tue, 15 Oct 2013 18:05:07 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/7] Power-aware scheduling v2
Message-ID: <20131015170507.GR31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <20131014133234.GM3081@twins.programming.kicks-ass.net>
 <20131014171541.GP31039@e103034-lin>
 <20131014173113.GB2675@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20131014173113.GB2675@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Oct 2013 17:04:58.0946 (UTC) FILETIME=[ADF4B220:01CEC9C8]
X-MC-Unique: 113101518050109201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 06:31:13PM +0100, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 06:15:41PM +0100, Morten Rasmussen wrote:
> > > In fact, I don't see anything except a random bunch of hooks without an
> > > over-all picture of how to get less power used.
> > 
> > I will follow up with a better description of the overall picture. The
> > slides I linked to are not really self-explaining.
> 
> I hadn't even noticed there were slides linked. In general I tend to
> ignore external links -- patches should be descriptive enough to stand
> on their own.

Elaborating a bit more on the big picture and where we can go with this
proposal, here are the main requirements:

1. A unified scheduler driven power policy, i.e. the scheduler drives
DVFS/idle (as suggested by Ingo and hence this first set of patches).

2. Small task packing. Avoid spreading tasks under light workloads.

In addition for big.LITTLE we need:

3. Task placement based cpu suitability. Associate task load ranges with
each cpu to give task placement. Heavy tasks on big, small tasks on
little.

This patch set addresses part of 1, while 3 will follow soon. Point 2 is
worked on by Vincent in collaboration with us.

The power driver introduced in this set has a role in the solution to
all three points. It serves as a unified platform power driver and the
interface allows the scheduler to get highlevel feedback which cpufreq
and cpuidle do not currently provide.

Decisions about the power/performance trade-off will be made in the
power driver guided by the hints from the scheduler. That allow
platforms the freedom to do what they want with the hints including
ignoring them completely (taking Arjan's previous comments into
account). It will make the power driver much powerful than the current
cpufreq/cpuidle drivers.

Morten 

