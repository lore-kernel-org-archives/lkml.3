Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974AbaFSVQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:16:39 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:55152 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965515AbaFSVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:16:37 -0400
Date: Thu, 19 Jun 2014 16:16:34 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
Message-ID: <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
References: <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com> <20140618203052.GT4669@linux.vnet.ibm.com> <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com> <alpine.DEB.2.11.1406190941180.2785@gentwo.org> <20140619180916.GE4904@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191531020.4002@gentwo.org> <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks very much like the CONFIG_PREEMPT problem in not so
extreme form. Maybe we need to add another config option:

CONFIG_REALLY_REALLY_NO_PREEMPT

to get the fastest code possible and those cond_rescheds removed from the
critical paths?

Or better

CONFIG_PREEMPT_HALF_WAY

to enable those cond_rescheds.

