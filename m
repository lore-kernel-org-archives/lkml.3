Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaELHjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:39:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:46581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaELHjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:39:44 -0400
Date: Mon, 12 May 2014 09:39:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/2] tick: SHUTDOWN event-dev if no events are required
 for KTIME_MAX
In-Reply-To: <CAKohpomDmCtrEuq2o8CYto7_bo+zAgyo99LntX8PY1tKhwcbig@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405120937350.6261@ionos.tec.linutronix.de>
References: <cover.1399623699.git.viresh.kumar@linaro.org> <0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1405091728450.6261@ionos.tec.linutronix.de> <alpine.DEB.2.02.1405101256430.6261@ionos.tec.linutronix.de>
 <CAKohpomDmCtrEuq2o8CYto7_bo+zAgyo99LntX8PY1tKhwcbig@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 May 2014, Viresh Kumar wrote:

> On 10 May 2014 16:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> > There is even a better way to do that:
> >
> > 1) Create a new callback set_state() which has an
> >    int return value.
> >
> > 2) Make the callsites do
> >
> >    if (dev->set_state) {
> >       ret = dev->set_state();
> >       handle_return_value();
> >    } else
> >       dev->set_mode();
> 
> Do you want me to touch clock_event_mode as well?
> Otherwise we will pass mode into a function setting state..
> 
> Or we can do s/mode/state after all the work suggested by you
> is done ..
> 
> Or leave as is..

You can name the new callback set_dev_mode() :)
 
set_state() was just pulled out of the air for illustration.

Thanks,

	tglx
