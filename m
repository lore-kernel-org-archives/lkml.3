Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbaKODc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 22:32:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934378AbaKODc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 22:32:56 -0500
Date: Fri, 14 Nov 2014 22:32:51 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Paul Moore <pmoore@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, eparis@parisplace.org
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Message-ID: <20141115033251.GB31373@madcap2.tricolour.ca>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
 <1745832.tbkjBzSGxr@sifl>
 <20141114010852.GB5960@madcap2.tricolour.ca>
 <2673987.auILhPtmMS@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2673987.auILhPtmMS@x2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/13, Steve Grubb wrote:
> On Thursday, November 13, 2014 08:08:52 PM Richard Guy Briggs wrote:
> > > So what terrible things happen to userspace if
> > > AUDIT_VERSION_BACKLOG_WAIT_TIME  becomes 0x03 instead of 0x02?
> > 
> > But it won't.  It gets the value of
> > AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME, which is 0x00000002.
> > 
> > I think you meant to ask about AUDIT_VERSION_LATEST, which would become 3.
> > 
> > You *did* already ask that question in a previous thread, and there
> > didn't seem to be a concern.  Steve Grubb could likely answer this
> > question better than me.
> 
> The audit 2.4.1 package has been pushed to everything from F20 -> rawhide. If 
> you don't see any problems, then its safe. But check carefully around the 
> things that you did change. Right now, we only are caring about only one 
> kernel feature, --loginuid-immutable. Check that it still works, auditctl -s.

Here's my output, which I assume looks sane:

[root@f20 ~]# rpm -q audit
audit-2.4.1-1.fc20.x86_64
[root@f20 ~]# auditctl -s
enabled 1
flag 1
pid 307
rate_limit 0
backlog_limit 320
lost 0
backlog 0
backlog_wait_time 60000
loginuid_immutable 0 unlocked

> -Steve

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
