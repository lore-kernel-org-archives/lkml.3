Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbaKNCvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:51:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080AbaKNCvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:51:39 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <pmoore@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, eparis@parisplace.org
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Date: Thu, 13 Nov 2014 21:51:36 -0500
Message-ID: <2673987.auILhPtmMS@x2>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141114010852.GB5960@madcap2.tricolour.ca>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com> <1745832.tbkjBzSGxr@sifl> <20141114010852.GB5960@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 08:08:52 PM Richard Guy Briggs wrote:
> > So what terrible things happen to userspace if
> > AUDIT_VERSION_BACKLOG_WAIT_TIME  becomes 0x03 instead of 0x02?
> 
> But it won't.  It gets the value of
> AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME, which is 0x00000002.
> 
> I think you meant to ask about AUDIT_VERSION_LATEST, which would become 3.
> 
> You *did* already ask that question in a previous thread, and there
> didn't seem to be a concern.  Steve Grubb could likely answer this
> question better than me.

The audit 2.4.1 package has been pushed to everything from F20 -> rawhide. If 
you don't see any problems, then its safe. But check carefully around the 
things that you did change. Right now, we only are caring about only one 
kernel feature, --loginuid-immutable. Check that it still works, auditctl -s.

-Steve
