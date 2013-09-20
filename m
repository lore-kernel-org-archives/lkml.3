Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3ITOsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3ITOsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:48:02 -0400
Message-ID: <1379688470.5434.4.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 7/8] audit: clean up AUDIT_GET/SET local variables and
 future-proof API
From: Eric Paris <eparis@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Date: Fri, 20 Sep 2013 10:47:50 -0400
In-Reply-To: <1557446.mvTTyrtVjc@x2>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
	 <3c8ba778c317db8e9d49fa44af736f4b122e4d06.1379530867.git.rgb@redhat.com>
	 <1557446.mvTTyrtVjc@x2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 17:18 -0400, Steve Grubb wrote:
> On Wednesday, September 18, 2013 03:06:52 PM Richard Guy Briggs wrote:
> > Re-named confusing local variable names (status_set and status_get didn't
> > agree with their command type name) and reduced their scope.
> > 
> > Future-proof API changes by not depending on the exact size of the
> > audit_status struct.
> 
> I wished things like this were coordinated before being written. We had some 
> discussion of this back in July under a topic, "audit: implement generic 
> feature setting and retrieving". Maybe that API can be fixed so its not just 
> set/unset but can take a number as well.

Your right, we did talk about it.  Though it seems we talked past each
other.  What was implemented was an on off extensible interface.  The
status interface already fits for setting numbers.  And because of how
it is used has been extended is is extensible for setting numbers.

> 
> Also, because there is no way to query the kernel to see what kind of things 
> it supports

I'll agree.  Richard, can you please add a version field to the status?
Start at version 1.  Any time we add a new audit feature we'll bump it.

> , we've typically defined a new message type and put into it exactly 
> what we need. In other words, if you want something expandable, the define a 
> new message type like AUDIT_GET_EXT and AUDIT_SET_EXT and build it to be 
> expandable.

There is no reason we can't use what we have.  (As we've done it before)

