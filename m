Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3LQO0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:26:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3LQO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:26:29 -0500
Message-ID: <1387290376.2399.11.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Date: Tue, 17 Dec 2013 15:26:16 +0100
In-Reply-To: <20131217091624.65be757c@gandalf.local.home>
References: <20131216091431.GA13796@linutronix.de>
	 <1387264591.5340.23.camel@marge.simpson.net>
	 <20131217063156.6ac3bfed@gandalf.local.home>
	 <20131217124248.GA21694@linutronix.de>
	 <20131217091624.65be757c@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:3rNzbJ9dfk3QvWIR4HXGNPbmn3fATSPRXV5rinkp2cM
 7gfblRWGSa1sbfdesC0PpKZVPhBEybjvy+RKcsMsjrNrFnIZHC
 Htkp/tyxq+IalQn+b1gcMjW7b4nSc4ujx73lp/nM5z6xz1Sp2I
 KiCF9ojQ99+xoqophYKl0iPg/E7F2jRJOTz+P+C7xtGYyjAaoh
 qsCT9k7lOAtCnG6TSZZ9HYFUA35W0rnMTktPAgAdzXsOBJExKi
 R+RfDiOGS+p1f9+39kkQawKEhftjqQPJhIU68VWbRE7NUhPrP+
 yMb5OUdouRBwj7VCbJ715Av/4Oz8OFjse/IHbXTmB+WqpjGF8V
 R7Oq2KKLY7VXErmYv4ElqWxT4peWqCpjHNlqonMEV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 09:16 -0500, Steven Rostedt wrote: 
> 
> > @@ -1129,11 +1127,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
> >  		 * is actually now running somewhere else!
> >  		 */
> >  		while (task_running(rq, p)) {
> > -			if (match_state) {
> > -				if (!unlikely(check_task_state(p, match_state)))
> > -					return 0;
> > +			if (match_state && !check_task_state(p, match_state))
> 
> Ah, it was that "!unlikely(" that caused me to miss the '!'. That
> should have been: likely(!check_task_state()). But anyway, I rather
> just keep what you wrote and drop the unlikely altogether.

Maybe better would be to put the thing back inline, with a brief
reference to the race.

-Mike

