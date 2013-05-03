Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486Ab3ECUKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762489Ab3ECUKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:10:51 -0400
Date: Fri, 3 May 2013 16:10:37 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
Message-ID: <20130503201037.GA17652@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130430213719.GA14988@redhat.com>
 <alpine.LFD.2.02.1305021234510.3972@ionos>
 <20130502154621.GA23990@redhat.com>
 <alpine.LFD.2.02.1305022152280.2891@ionos>
 <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
 <alpine.LFD.2.02.1305022304370.2891@ionos>
 <CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
 <alpine.LFD.2.02.1305022337470.2891@ionos>
 <20130503144912.GB1283@redhat.com>
 <alpine.LFD.2.02.1305032015060.2990@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305032015060.2990@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 08:32:58PM +0200, Thomas Gleixner wrote:
 > On Fri, 3 May 2013, Dave Jones wrote:
 > > On Fri, May 03, 2013 at 12:49:20AM +0200, Thomas Gleixner wrote:
 > > 
 > >  > I'm fundamentally confused and Daves observation about slub debug does
 > >  > not make it less confusing.
 > >  > 
 > >  > It'd be nice if you could add some more instrumentation or bisect the
 > >  > issue.
 > > 
 > > Here's what I ended up with..
 > > b352bc1cbc29134a356b5c16ee2281807a7b984e is the first bad commit
 > > commit b352bc1cbc29134a356b5c16ee2281807a7b984e
 > > Author: Thomas Gleixner <tglx@linutronix.de>
 > > Date:   Tue Mar 5 14:25:32 2013 +0100
 > > 
 > >     tick: Convert broadcast cpu bitmaps to cpumask_var_t
 > >     
 > >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 > >     Link: http://lkml.kernel.org/r/20130306111537.366394000@linutronix.de
 > >     Cc: Rusty Russell <rusty@rustcorp.com.au>
 > > 
 > 
 > I bet you have CONFIG_CPUMASK_OFFSTACK enabled.
 > 
 > /me is a moron and rumages for a brown paperbag.
 > 
 > Patch below.

Works for me.

Tested-by: Dave Jones <davej@redhat.com>

