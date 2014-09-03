Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbaICPvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:51:17 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:50608
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932678AbaICPvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:51:16 -0400
Date: Wed, 3 Sep 2014 10:51:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140903144349.GT5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409031043540.24085@gentwo.org>
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org> <20140902203743.GL5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021545370.32690@gentwo.org> <20140902211517.GO5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
 <20140903021152.GA14069@linux.vnet.ibm.com> <alpine.DEB.2.11.1409030846310.9372@gentwo.org> <20140903144349.GT5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2014, Paul E. McKenney wrote:

> You would prefer that I instead allocated an NR_CPUS-sized array?

Well, a shared data structure would be cleaner in general but there are
certainly other approaches.

But lets focus on the dynticks_idle case we are discussing here rather
than tackle the more difficult other atomics. What is checked in the loop
over the remote cpus is the dynticks_idle value plus
dynticks_idle_jiffies. So it seems that memory ordering is only used to
ensure that the jiffies are seen correctly.

In that case both the dynticks_idle and dynticks_idle_jiffies could be
placed in one 64 bit value. If this is stored and retrieved as one then
there is no issue with ordering anymore and the barriers would no longer
be needed.
