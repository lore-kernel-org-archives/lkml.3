Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaBZDpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:45:44 -0500
Received: from ozlabs.org ([203.10.76.45]:50203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaBZDpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:45:42 -0500
Message-ID: <1393386338.29388.5.camel@concordia>
Subject: Re: [PATCH] powerpc: warn users of smt-snooze-delay that the API
 isn't there anymore
From: Michael Ellerman <mpe@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Date: Wed, 26 Feb 2014 14:45:38 +1100
In-Reply-To: <1393368002.6314.10.camel@pasglop>
References: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
	 <530C4D57.1030905@linux.vnet.ibm.com> <1393368002.6314.10.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 09:40 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2014-02-25 at 13:29 +0530, Deepthi Dharwar wrote:
> > We currently do not use smt-snooze-delay in the kernel.
> > The sysfs entries needs to  be retained until we do a clean up
> > ppc64_cpu
> > util that uses these entries to determine SMT,
> > clean up patch for this has already been posted out by Prerna.
> > Once, we have the ppc64_cpu changes in, we can look to clean up these
> > parts from the kernel.
> 
> We generally shouldn't change user visible interfaces.
> 
> People still have old versions of ppc64_cpu, we must not break them

Yeah we can't remove the file entirely, at least for a few more years.

ppc64_cpu should never have used that file to determine if a cpu existed, but
it did, so we're stuck with it.

What we can do is remove the unused percpu, and just leave the file in sysfs,
and have it print a warning when anyone touches it.

cheers


