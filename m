Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3F1KwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:52:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:45524 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3F1KwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:52:02 -0400
Date: Fri, 28 Jun 2013 12:52:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
In-Reply-To: <51CC708B.7040605@redhat.com>
Message-ID: <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de>
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com> <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de> <51CC708B.7040605@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Prarit Bhargava wrote:
> On 06/26/2013 07:05 AM, Thomas Gleixner wrote:
> > Subject: tick: Make oneshot broadcast robust vs. CPU offlining
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Wed, 26 Jun 2013 12:17:32 +0200
> > 
> > In periodic mode we remove offline cpus from the broadcast propagation
> > mask. In oneshot mode we fail to do so. This was not a problem so far,
> > but the recent changes to the broadcast propagation introduced a
> > constellation which can result in a NULL pointer dereference.
> > 
> 
> Unfortunately this patch causes an NMI watchdog during system shutdown.  Most of
> the CPUs are in start_secondary+0x254/0x256.

Huch. Did the warning in the broadcast code trigger before that?
 
Thanks,

	tglx
