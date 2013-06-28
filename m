Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3F1KqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:46:00 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:60877 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3F1Kp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:45:59 -0400
Date: Fri, 28 Jun 2013 12:45:49 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Maxim Uvarov <muvarov@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Wladislav Wiebe <wladislav.kw@gmail.com>, david.daney@cavium.com,
        davem@davemloft.net, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] MIPS: Octeon: fix for held reboot_mutex lock at
 task exit time
Message-ID: <20130628104548.GL10727@linux-mips.org>
References: <519DDF8D.70700@gmail.com>
 <519E4C3C.7010400@gmail.com>
 <CAJGZr0KRAJty5+hY77e8s50NmK5jLq8zNQ_r6fz9LOVpPo_WCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGZr0KRAJty5+hY77e8s50NmK5jLq8zNQ_r6fz9LOVpPo_WCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply - this ended up in the moderator queue for the
mailing list and I rarely look at it - it's tens of thousands of emails!
  
On Thu, May 23, 2013 at 11:58:34PM +0400, Maxim Uvarov wrote:

> >> diff --git a/arch/mips/cavium-octeon/**setup.c b/arch/mips/cavium-octeon/
> >> **setup.c
> >> index b0baa29..04ce396 100644
> >> --- a/arch/mips/cavium-octeon/**setup.c
> >> +++ b/arch/mips/cavium-octeon/**setup.c
> >> @@ -457,6 +457,10 @@ static void octeon_halt(void)
> >>         }
> >>
> >>         octeon_kill_core(NULL);
> >> +
> >> +       /* We stop here */
> >> +       while (1)
> >> +               ;
> >>
> >
> > I want to put a WAIT here so we don't burn so much power.
> >
> > I will send a patch to do that instead.
> >
> >
> what about adding wait for other mips boards where is while (1) is used?

Many platforms have their own variants of eternal loops, some using
just "while (1);", others trying to save power using the WAIT instruction.
I was planing to work through all of them and come up with a common
defaut implementation.

  Ralf
