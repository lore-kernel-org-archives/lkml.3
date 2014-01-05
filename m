Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaAEWFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:05:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaAEWFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:05:09 -0500
Date: Sun, 5 Jan 2014 17:04:58 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Bart Van Assche <bvanassche@acm.org>
cc: Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org,
        device-mapper development <dm-devel@redhat.com>,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix
 module unload race
In-Reply-To: <52C98BCC.9040900@acm.org>
Message-ID: <alpine.LRH.2.02.1401051651120.17316@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jan 2014, Bart Van Assche wrote:

> On 01/04/14 19:06, Mikulas Patocka wrote:
> > -	if (t && !t->release)
> > -		pr_debug("kobject: '%s' (%p): does not have a release() "
> > -			 "function, it is broken and must be fixed.\n",
> > -			 kobject_name(kobj), kobj);
> > -
> 
> Has it been considered to issue a warning if no release function has
> been defined and free_completion == NULL instead of removing the above
> debug message entirely ? I think even with this patch applied it is
> still wrong to invoke kobject_put() on an object without defining a
> release function.
> 
> Thanks,
> 
> Bart.

With the above patch, you don't need the release method for correct 
behavior. Therefore you don't have to issue warning when it is missing.

Mikulas
