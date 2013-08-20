Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3HTBCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:02:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3HTBCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:02:10 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=3wfm---skdX-aecXHHkA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 19 Aug 2013 21:02:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kent Overstreet <kmo@daterainc.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130819210208.426e01b3@gandalf.local.home>
In-Reply-To: <20130819202903.692097ea@gandalf.local.home>
References: <20130812163413.GI23040@linutronix.de>
	<520D212F.7030400@localhost>
	<20130815152210.5ed93696@gandalf.local.home>
	<520DCE5F.1040402@linutronix.de>
	<521254A0.6050603@localhost>
	<20130819202903.692097ea@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 20:29:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 19 Aug 2013 10:23:44 -0700
> Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> 
> > > The problem is that bcache is using new semaphore functions which it
> > > just introduced which rt does not know about. The comment above their
> > > definition says that it is wrong to use them and completion is the
> > > right way to do it.
> > > So my question is, why don't we use completion but this nasty hack?
> 
> I think I'm going to send them an email about that.
> 

Looking at it more, I can now see why they did what they did.

Grumble, we may need to bring back the old "compat" rwsem, or whatever
we called it, and just use that instead. And say that this code will
have no real time boosting.

-- Steve
