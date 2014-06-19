Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbaFSUcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:32:00 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:43036
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071AbaFSUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:31:59 -0400
Date: Thu, 19 Jun 2014 15:31:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140619180916.GE4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
References: <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com> <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com> <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com> <20140619014200.GO8178@tassilo.jf.intel.com> <alpine.DEB.2.11.1406190941180.2785@gentwo.org> <20140619180916.GE4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> That is a separate issue, but unnecessary calls to cond_resched()
> should of course be removed -- no argument there.

It looks like we are fighting higher latencies by adding calls in most of
the critical sections which will in turn increase the latencies that we
are trying to reduce.

