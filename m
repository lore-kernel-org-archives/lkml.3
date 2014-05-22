Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaEVNgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:36:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37247 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaEVNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:36:41 -0400
Date: Thu, 22 May 2014 15:36:35 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: BCM1480: remove checks for
 CONFIG_SIBYTE_BCM1480_PROF
Message-ID: <20140522133635.GE10287@linux-mips.org>
References: <1400750659.16832.24.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400750659.16832.24.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:24:19AM +0200, Paul Bolle wrote:

> There are two checks for CONFIG_SIBYTE_BCM1480_PROF in the tree since
> v2.6.15. The related Kconfig symbol has never been added to the tree. So
> these checks have always evaluated to false. Besides, one of these
> checks guards a call of sbprof_cpu_intr(). But that function is not
> defined. Remove all this.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> Until v2.6.23 there also were checks for CONFIG_SIBYTE_SB1250_PROF in
> the tree. There also was a Kconfig symbol SIBYTE_SB1250_PROF so it was
> possible to make these checks evaluate to true. But, since one of these
> checks also guarded a call of sbprof_cpu_intr(), that should have made
> the build fail with an error.

The Sibyte profiling was far inferior to later solutions such as oprofile
or perf and non-standard anyway.  So let's kill what's left over.

  Ralf
