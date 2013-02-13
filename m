Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab3BMQmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:42:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:60084 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab3BMQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:42:36 -0500
Date: Wed, 13 Feb 2013 17:42:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@gmail.com>, Clark Williams <clark@redhat.com>
Subject: Re: [RFC][PATCH RT] acpi/rt: Convert acpi lock back to a
 raw_spinlock_t
In-Reply-To: <1360765565.23152.5.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1302131741220.11905@ionos>
References: <1360765565.23152.5.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, Steven Rostedt wrote:
> The lock was converted from a raw to a sleeping lock due to some
> previous issues, and tests that showed it didn't seem to matter.
> Unfortunately, it did matter for one of our boxes.

Yep. The other issues are functions like kfree() called under that
lock. I'm auditing all callsites to see what needs to be done.

Thanks,

	tglx
