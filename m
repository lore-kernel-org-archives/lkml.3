Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3KMQHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:07:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:54404 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3KMQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:07:24 -0500
Date: Wed, 13 Nov 2013 17:07:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: nohz problem with idle time on old hardware
In-Reply-To: <20131113105737.3f7a0b1b@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
References: <20131113113927.GA13875@mwhitehe.csb> <alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de> <20131113102153.5f10e6b5@gandalf.local.home> <20131113103134.5b8cf02f@gandalf.local.home> <20131113105737.3f7a0b1b@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013, Steven Rostedt wrote:

> On Wed, 13 Nov 2013 10:31:34 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
> > The trace does indeed show that a tick is happening, as the config has
> > HZ=250 (4ms) and we see a tick happen every 4ms. But for some reason,
> > we don't update the the idle time correctly when nohz is enabled.
> > 
> > When I say nohz is enabled, I mean that we don't have nohz=off in the
> > command line. There seems to be some difference between having nohz=off
> > and having nohz disabled at runtime.
> 
> 
> Looking at the differences between nohz=off from the command line, and
> disabled at run time seems to be the variable "tick_nohz_enabled". I
> don't see where it gets set to zero except for nohz=off.

Right. It's telling you if NOHZ is enabled. It's not telling you that
NOHZ is active.

Thanks,

	tglx
