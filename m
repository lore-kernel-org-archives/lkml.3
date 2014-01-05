Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaAES03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:26:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaAES02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:26:28 -0500
Date: Sun, 5 Jan 2014 10:26:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
        torvalds@linux-foundation.org,
        device-mapper development <dm-devel@redhat.com>,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix
 module unload race
Message-ID: <20140105182640.GA2522@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <52C98BCC.9040900@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C98BCC.9040900@acm.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 05:43:56PM +0100, Bart Van Assche wrote:
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

This patch isn't going to be applied, and I've reverted the original
commit, so there shouldn't be any issues anymore with this code.

thanks,

greg k-h
