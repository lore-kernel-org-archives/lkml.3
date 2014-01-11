Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaAKU0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:26:01 -0500
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:36122 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAKUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:25:58 -0500
Date: Sat, 11 Jan 2014 21:25:50 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20140111212550.2dca4829@tor.valhalla.alchemy.lu>
In-Reply-To: <20131227200024.GA19505@opentech.at>
References: <20131223225017.GA8623@linutronix.de>
	<20131227200024.GA19505@opentech.at>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013 21:00:24 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> On Mon, 23 Dec 2013, Sebastian Andrzej Siewior wrote:
> 
> > Dear RT folks!
> > 
> > I'm pleased to announce the v3.12.6-rt9 patch set.
> > 
> > Changes since v3.12.6-rt8
> <snip>
> > - A patch from Thomas Gleixner not to raise the timer softirq
> >   unconditionally (only if a timer is pending)
> > 
> 
> This one seems to deadlock early in the boot sequence on x86
> (i3/i7/Phenom-4x here and Carsten Emde also had boot failures)

This patch seems to frequently make the kernel hang hard early in the
boot process on my i7-2600k too. Reverting
timers-do-not-raise-softirq-unconditionally.patch appears to fix the
problem.

-- 

   Joakim
