Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161768AbaDPPMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:12:20 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:53953
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325AbaDPPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:12:18 -0400
Date: Wed, 16 Apr 2014 10:12:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tj@kernel.org, grygorii.strashko@ti.com
Subject: Re: How do I increment a per-CPU variable without warning?
In-Reply-To: <20140416052147.GK26782@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404161008390.9945@gentwo.org>
References: <20140415221755.GA27188@linux.vnet.ibm.com> <20140415222951.GA742@redhat.com> <20140415224725.GS4496@linux.vnet.ibm.com> <20140416035419.GA30105@linux.vnet.ibm.com> <20140416052147.GK26782@laptop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Peter Zijlstra wrote:

> You really want to disable preemption around there. The proper old way
> would've been get_cpu_var()/put_cpu_var().

get_cpu_var and put_cpu_var is still the correct way of doing things if
you need to access multiple per cpu variables.

The problem that I want to solve is the varied use of
__get_cpu_var for address calculations, per cpu variable assignment,
structure copying and per cpu variable access. The this_cpu ops can avoid
address calculations using segment prefixes. Plus the changes clarify what
is actuallly going on.


