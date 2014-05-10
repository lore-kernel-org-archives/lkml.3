Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaEJLBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 07:01:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:40575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaEJLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 07:01:04 -0400
Date: Sat, 10 May 2014 13:01:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org
Subject: Re: [PATCH 2/2] tick: SHUTDOWN event-dev if no events are required
 for KTIME_MAX
In-Reply-To: <alpine.DEB.2.02.1405091728450.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1405101256430.6261@ionos.tec.linutronix.de>
References: <cover.1399623699.git.viresh.kumar@linaro.org> <0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1405091728450.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Thomas Gleixner wrote:
> On Fri, 9 May 2014, Viresh Kumar wrote:
> So the right thing to do this is:
> 
> 1A) Change the prototype of the set_mode callback to return int and
>     fixup all users. Either add the missing default clause or remove
>     the existing BUG()/ pr_err()/whatever handling in the existing
>     default clause and return a UNIQUE error code.
> 
>     I know I should have done that from the very beginning, but in
>     hindsight one could have done everything better.
> 
>     coccinelle is your friend (if you need help ask me or Julia
>     Lawall). But it's going to be quite some manual work on top.

There is even a better way to do that:

1) Create a new callback set_state() which has an
   int return value.

2) Make the callsites do

   if (dev->set_state) {
      ret = dev->set_state();
      handle_return_value();
   } else
      dev->set_mode();

3) Convert implementations one by one to use the new callback

4) Remove the set_mode callback

5) Implement new features.

Thanks,

	tglx
