Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaH0Htw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:49:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:59323 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaH0Htv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:49:51 -0400
Date: Wed, 27 Aug 2014 09:49:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] genirq: bug on inconstent flags and flow handler
In-Reply-To: <53FD1E1A.6020404@gmail.com>
Message-ID: <alpine.DEB.2.10.1408270949380.3323@nanos>
References: <1406141136-19501-1-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.10.1407232048240.23352@nanos> <CAGVrzcbMKOGV20OGWY9n7xw3f=6+oyRvza+qRbCHfbVECmTLNQ@mail.gmail.com> <53FD1E1A.6020404@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Florian Fainelli wrote:

> On 07/23/2014 12:14 PM, Florian Fainelli wrote:
> > 2014-07-23 11:49 GMT-07:00 Thomas Gleixner <tglx@linutronix.de>:
> >> On Wed, 23 Jul 2014, Florian Fainelli wrote:
> >>
> >>> It is currently possible for a generic irq chip driver to set IRQ_LEVEL
> >>> and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
> >>> such a case does not make sense, and will actually prevent e.g: the
> >>> software resend logic from kicking, and potential other problems too.
> >>>
> >>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>> ---
> >>> Changes in v2:
> >>> - replaced WARN_ON() with BUG_ON() since we really don't want to continue
> >>>   as suggested by Jason Cooper
> >>
> >> I disagree here. It's not a reason take the machine down. Its good
> >> enough to WARN. That keeps the machine alive and lets us debug that
> >> stuff.
> > 
> > Works for me!
> > 
> >>
> >> Lemme find V1 ....
> > 
> > Here it is: https://lkml.org/lkml/2014/7/1/468
> 
> Thomas, do you want me to resubmit that change so you get a clean
> submission in your inbox? Thanks

Yes please
