Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaCRViD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:38:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaCRViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:38:00 -0400
Date: Tue, 18 Mar 2014 14:37:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [linux-next][regression] [PATCH] percpu: add preemption checks
 to __this_cpu ops
Message-Id: <20140318143759.04a892434d84a9fd3aa94262@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1403181053110.23935@nuc>
References: <53285FE7.5010203@ti.com>
	<alpine.DEB.2.10.1403180922050.17965@nuc>
	<53286ABF.3040408@ti.com>
	<alpine.DEB.2.10.1403181053110.23935@nuc>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 10:54:06 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:

> On Tue, 18 Mar 2014, Grygorii Strashko wrote:
> 
> > Any way, I can boot and console works fine with your change :)
> > Thanks.
> 
> Ok here is the properly formatted patch:
> 
> 
> Subject: preemption_checks: Avoid snprintf before checking error conditions
> 
> snprintf can cause hangs.

This is weird.  How the heck can snprintf() fail if called too early? 
All it does is shuffle chars around in memory.  The only external
dependency I'm seeing is a WARN_ON() which presumably didn't trigger
anyway.

I'm suspecting a misdiagnosis here.  Otherwise, we seriously need to
fix snprintf(), not work around it!

Also, what does "before checking error conditions" refer to?  Does this
mean you know why snprintf() failed??

> Move the string processing into the function
> so that the string operations only occur when necessary after the
> conditions have been checked.
> 
> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>

Grygorii, thanks for testing linux-next on unusual machines - it's most
helpful.

> Signed-off-by: Christoph Lameter <cl@linux.com>

