Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3CYP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:27:34 -0400
Received: from a192-102.smtp-out.amazonses.com ([199.255.192.102]:19365 "EHLO
	a192-102.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758128Ab3CYP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:27:33 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 11:27:33 EDT
Date: Mon, 25 Mar 2013 15:18:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <CAFTL4hzFmrHPHhi3gBj05eJgxb5H7bACEWwCm7jp6Vb0XU15bA@mail.gmail.com>
Message-ID: <0000013da220b8b2-ed8dbc75-ac8c-4e1c-94df-c62f1625ec3a-000000@email.amazonses.com>
References: <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home> <20130320235545.GL3637@linux.vnet.ibm.com> <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com> <20130321171518.GW3637@linux.vnet.ibm.com>
 <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com> <20130321185821.GF3637@linux.vnet.ibm.com> <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com> <20130321205054.GI3637@linux.vnet.ibm.com>
 <0000013d9289cebc-e6380265-3a74-4343-b851-765f785a3754-000000@email.amazonses.com> <20130322162820.GN3637@linux.vnet.ibm.com> <0000013da1f6170e-7b247826-93a9-4c2d-a316-ba3b0597a805-000000@email.amazonses.com>
 <CAFTL4hzFmrHPHhi3gBj05eJgxb5H7bACEWwCm7jp6Vb0XU15bA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Frederic Weisbecker wrote:

> > The vm kernel threads do no useful work if no system calls are being done.
> > If there is no kernel action then they can be deferred indefinitely.
> >
>
> We can certainly add some user deferrable timer_list. But that's going
> to be for extreme usecases (those who require pure isolation) because
> we'll need to settle that with a timer reprogramming into user/kernel
> boundaries. That won't be free.

These timers are already marked deferrable and are deferred for the idle
dynticks case. Could we reuse the same logic? See timer.h around the
define of TIMER_DEFERRABLE. I just assumed so far that the dyntick idle
logic would have been used for this case.

