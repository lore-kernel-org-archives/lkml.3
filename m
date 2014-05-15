Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaEOSE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbaEOSE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:04:58 -0400
Date: Thu, 15 May 2014 20:04:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: WARN in do_rt_tgsigqueueinfo()
Message-ID: <20140515180409.GA5972@redhat.com>
References: <20140515133834.GN13658@twins.programming.kicks-ass.net> <20140515142723.GB22041@mguzik.redhat.com> <20140515150412.GP30445@twins.programming.kicks-ass.net> <20140515155415.GA326@redhat.com> <20140515160950.GA22846@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515160950.GA22846@mguzik.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15, Mateusz Guzik wrote:
>
> On Thu, May 15, 2014 at 11:54:15AM -0400, Dave Jones wrote:
> >
> > I'm of the opinion that a user-triggerable WARN is a bug, but aparently
> > not everyone else feels that way.

I didn't really like this WARN_ONCE() when I looked at the patch which
added it, but I didn't try to argue.

> imho warning sysadmins about userspace using deprecated stuff is fine as
> long as users are not able to spam the console with it.

Agreed,

> Warning reported here just looks scary and provides no information for
> sysadmins so I guess it hould be changed.

Again, agreed.

So imo we should either remove it, ot turn it into

	pr_warn_once("something meaningful");

Oleg.

