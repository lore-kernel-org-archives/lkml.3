Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbaFCWPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:15:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:59691 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbaFCWPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:15:49 -0400
Message-ID: <1401833365.3247.36.camel@pasglop>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, paulus@samba.org, ebiederm@xmission.com,
        mahesh@linux.vnet.ibm.com, ananth@in.ibm.com, suzuki@in.ibm.com,
        ego@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        matt@ozlabs.org
Date: Wed, 04 Jun 2014 08:09:25 +1000
In-Reply-To: <538E2FF8.8060707@linux.vnet.ibm.com>
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com>
	 <20140528133143.GK14863@redhat.com> <538E2FF8.8060707@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 01:58 +0530, Srivatsa S. Bhat wrote:
> Yep, that makes sense. But unfortunately I don't have enough insight into
> why exactly powerpc has to online the CPUs before doing a kexec. I just
> know from the commit log and the comment mentioned above (and from my own
> experiments) that the CPUs will get stuck if they were offline. Perhaps
> somebody more knowledgeable can explain this in detail and suggest a proper
> long-term solution.
> 
> Matt, Ben, any thoughts on this?

The problem is with our "soft offline" which we do on some platforms. When we
offline we don't actually send the CPUs back to firmware or anything like that.

We put them into a very low low power loop inside Linux.

The new kernel has no way to extract them from that loop. So we must re-"online"
them before we kexec so they can be passed to the new kernel normally (or returned
to firmware like we do on powernv).

Cheers,
Ben.


