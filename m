Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3CDKte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:49:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab3CDKtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:49:33 -0500
Date: Mon, 4 Mar 2013 11:49:16 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 4/6] uretprobes: return probe entry, prepare
 uretprobe
Message-ID: <20130304104916.GC32740@bandura.brq.redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com>
 <1362049215-5780-5-git-send-email-anton@redhat.com>
 <20130303164029.GA20088@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130303164029.GA20088@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 05:40:29PM +0100, Oleg Nesterov wrote:
> On 02/28, Anton Arapov wrote:
> >
> > @@ -69,6 +69,10 @@ struct uprobe_task {
> >  	enum uprobe_task_state		state;
> >  	struct arch_uprobe_task		autask;
> >
> > +	/*
> > +	 * list for tracking uprobes with return consumers
> > +	 */
> > +	struct hlist_head		return_uprobes;
> 
> Forgot to mention, at least you should also change uprobe_free_utask()
> to cleanup this list, the task can exit from inside the ret-probe'd
> function(s).

Yes, right. Thanks for the other mails as well. I will fix it for the
next RFC v4.

Anton.

> Oleg.
> 
