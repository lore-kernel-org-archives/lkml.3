Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbaCTOGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:06:38 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:42484 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaCTOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:06:37 -0400
Date: Thu, 20 Mar 2014 09:06:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [linux-next][regression] [PATCH] percpu: add preemption checks
 to __this_cpu ops
In-Reply-To: <20140318143759.04a892434d84a9fd3aa94262@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403200905070.4107@nuc>
References: <53285FE7.5010203@ti.com> <alpine.DEB.2.10.1403180922050.17965@nuc> <53286ABF.3040408@ti.com> <alpine.DEB.2.10.1403181053110.23935@nuc> <20140318143759.04a892434d84a9fd3aa94262@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Andrew Morton wrote:

> > snprintf can cause hangs.
>
> This is weird.  How the heck can snprintf() fail if called too early?
> All it does is shuffle chars around in memory.  The only external
> dependency I'm seeing is a WARN_ON() which presumably didn't trigger
> anyway.
>
> I'm suspecting a misdiagnosis here.  Otherwise, we seriously need to
> fix snprintf(), not work around it!
>
> Also, what does "before checking error conditions" refer to?  Does this
> mean you know why snprintf() failed??

No I dont. I only know that this fixes Grygorii's issues. There could be
numerous arch specific per cpu setup issues going on that may impact on
snprintf.

If I move it behind the checks then I can avoid using snprintf.
