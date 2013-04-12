Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3DLVQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab3DLVQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:16:39 -0400
Date: Fri, 12 Apr 2013 17:16:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130412211627.GM79013@redhat.com>
References: <20130408124858.GC79013@redhat.com>
 <20130408151509.GA20919@roeck-us.net>
 <20130409144431.GL79013@redhat.com>
 <20130409145228.GA1111@roeck-us.net>
 <20130409151423.GM79013@redhat.com>
 <20130409160757.GA27050@roeck-us.net>
 <20130410134039.GV79013@redhat.com>
 <20130410135123.GB15456@roeck-us.net>
 <20130410142055.GW79013@redhat.com>
 <20130410151041.GA6670@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410151041.GA6670@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 08:10:41AM -0700, Guenter Roeck wrote:
> > have no idea how to even find out if multiple watchdogs are open on the
> > system.  Is there a list I could walk?  And with regard to 'watchdog is
> 
> /* the dev_t structure to store the dynamically allocated watchdog devices */
> static dev_t watchdog_devt;
> 
> One way to look up the allocated watchdogs might be to loop through all kobj
> instances for the major device using kobj_lookup. Don't know if there is a
> better way.

Hmm, I got around to poking at this today and I am not sure kobj_lookup
will work.  Besides being surrounded with another mutex, I don't have
access to the character device domain to pass to kobj_lookup.

Perhaps I am not reading the code right, but I can't find a good way
forward.

The only other hack I can think of, is to embed a list object in the
watchdog structure and list_add each new register'd watchdog.  Then it
would be trivial to walk the watchdog list.

Thoughts?

Cheers,
Don

> 
> > running', I thought 'watchdog_active' would do that.  But again, I could
> > be misreading the code.
> > 
> You are right. Missed that part, sorry.
> 
> Guenter
