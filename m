Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaELHHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:07:30 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58981 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaELHH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405101256430.6261@ionos.tec.linutronix.de>
References: <cover.1399623699.git.viresh.kumar@linaro.org>
	<0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1405091728450.6261@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1405101256430.6261@ionos.tec.linutronix.de>
Date: Mon, 12 May 2014 12:37:27 +0530
Message-ID: <CAKohpomDmCtrEuq2o8CYto7_bo+zAgyo99LntX8PY1tKhwcbig@mail.gmail.com>
Subject: Re: [PATCH 2/2] tick: SHUTDOWN event-dev if no events are required
 for KTIME_MAX
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2014 16:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> There is even a better way to do that:
>
> 1) Create a new callback set_state() which has an
>    int return value.
>
> 2) Make the callsites do
>
>    if (dev->set_state) {
>       ret = dev->set_state();
>       handle_return_value();
>    } else
>       dev->set_mode();

Do you want me to touch clock_event_mode as well?
Otherwise we will pass mode into a function setting state..

Or we can do s/mode/state after all the work suggested by you
is done ..

Or leave as is..

1 & 2, should be just 1-2 patches, I will try to send them as soon
as possible. Once these get your nod, will start working on fixing
all the clockevent drivers.

--
viresh
