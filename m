Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaDBSxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494AbaDBSxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:53:04 -0400
Date: Wed, 2 Apr 2014 14:52:50 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-ima-user <linux-ima-user@lists.sourceforge.net>
Subject: oraphaned keywords in audit log text [was: Re: [PATCH] integrity:
 get comm using lock to avoid race in string] printing
Message-ID: <20140402185250.GB24814@madcap2.tricolour.ca>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
 <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
 <6292885.20TorKeRiK@x2>
 <1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
 <1396462716.2608.1.camel@localhost>
 <1396463260.20325.28.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396463260.20325.28.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/02, Mimi Zohar wrote:
> On Wed, 2014-04-02 at 14:18 -0400, Eric Paris wrote: 
> > On Wed, 2014-04-02 at 14:12 -0400, Mimi Zohar wrote:
> > > On Wed, 2014-04-02 at 14:00 -0400, Steve Grubb wrote: 
> > > > Hello Mimi,
> > > > 
> > > > On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
> > > > > This change is already being upstreamed as commit 73a6b44 "Integrity:
> > > > > Pass commname via get_task_comm()".
> > > > 
> > > > While I was looking at Richard's patch, I noticed a few places where cause and 
> > > > op are logged and the string isn't tied together with a _ or -. These are in 
> > > > ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are 
> > > > these fixed upstream? Or should a patch be made?
> > > 
> > > Nothing has changed in terms of 'cause' and 'op'.  I would suggest
> > > making the changes in integrity_audit.c: integrity_audit_msg().

That function could massage incoming text fields and convert spaces to
hyphens or underscores, but I'd assume the right place to do it would be
in the original text.  If you suggest the former, it could just be done
in audit_log_string(), but then grepping the source for error messages
would not be nearly as useful.  Is this what you were suggesting?

> > The question is actually, do you know of anyone who is expecting the
> > space, instead of a more 'audit standard' - or _ ?  If not, we'll change
> > it.  If so, we'll discuss more   :)
> 
> CC'ing linux-ima-user as well.

Thanks.

> Mimi

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
