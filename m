Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3FNTNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:13:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34659 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab3FNTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:13:14 -0400
Message-ID: <1371237192.2726.46.camel@dabdike>
Subject: Re: [PATCH RESEND] fix WARNING: at kernel/cpu/idle.c:96
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Jun 2013 12:13:12 -0700
In-Reply-To: <51BB6AE3.8030903@gmail.com>
References: <1371236142.2726.43.camel@dabdike> <51BB6AE3.8030903@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 12:11 -0700, David Daney wrote:
> On 06/14/2013 11:55 AM, James Bottomley wrote:
> >>From 48bbf44a96676ce6f520a408378730c976e9a11e Mon Sep 17 00:00:00 2001
> > From: James Bottomley <JBottomley@Parallels.com>
> > Date: Wed, 8 May 2013 14:05:34 -0700
> > Subject: [PATCH] [PARISC] fix WARNING: at kernel/cpu/idle.c:96
> >
> > On PA-RISC (and presumably any other arch that doesn't implement its own
> > arch_cpu_idle), we get this spurious boot warning.  The problem is that the
> > way the idle task is selected initially using the weak arch_cpu_idle() in
> > idle.c causes us to enter this place once with interrupts enabled.  Fix this
> > by disabling interrupts in the weak arch_cpu_idle() code.
> 
> Is this changelog correct?  It looks to me like you are enabling 
> interrupts down there.

Yes, obvious typo, sorry.  The WARN_ON check is for disabled interrupts
the fix is to enable them.

James


