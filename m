Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab3CYOoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:44:30 -0400
Received: from a192-166.smtp-out.amazonses.com ([199.255.192.166]:9855 "EHLO
	a192-166.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758445Ab3CYOoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:44:25 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 10:44:25 EDT
Date: Mon, 25 Mar 2013 14:34:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <1364010673.6345.156.camel@gandalf.local.home>
Message-ID: <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com>
References: <1363906545.6345.81.camel@gandalf.local.home> <0000013d92c37ff3-5fb85400-bec1-4eda-8ba1-332566884c59-000000@email.amazonses.com> <1364010673.6345.156.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Steven Rostedt wrote:

> I uploaded it here:
>
> http://rostedt.homelinux.com/private/slab_partials
>
> See anything I should be worried about?

Looks fine. Maybe its the spinlocks being contended that cause the
long holdoff? How does RT deal with the spinlocks? Dont know too much
about it.

You can eliminate the whole thing by setting

/sys/kernel/slab/<whatever/cpu_partial

to zero.

