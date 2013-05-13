Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EMBXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3EMBXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:23:32 -0400
Message-ID: <1368408162.929.17.camel@localhost>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity
 in audit rules and data
From: Eric Paris <eparis@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Sun, 12 May 2013 21:22:42 -0400
In-Reply-To: <3133489.jB2ld18Orb@x2>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
	 <87ip3w59gr.fsf@xmission.com> <20130416193823.GH6530@madcap2.tricolour.ca>
	 <3133489.jB2ld18Orb@x2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 09:29 -0400, Steve Grubb wrote:
> On Tuesday, April 16, 2013 03:38:23 PM Richard Guy Briggs wrote:
> > On Tue, Apr 09, 2013 at 02:39:32AM -0700, Eric W. Biederman wrote:
> > > Andrew Morton <akpm@linux-foundation.org> writes:
> > > > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> 
> wrote:
> > > >> audit rule additions containing "-F auid!=4294967295" were failing with
> > > >> EINVAL.> 
> > > The only case where this appears to make the least little bit of sense
> > > is if the goal of the test is to test to see if an audit logloginuid
> > > has been set at all.  In which case depending on a test against
> > > 4294967295 is bogus because you are depending on an intimate internal
> > > kernel implementation detail.
> > > 
> > > How about something like my untested patch below that add an explicit
> > > operation to test if loginuid has been set?
> > 
> > Sorry for the delay in testing this, I had another urgent bug and a
> > belligerent test box...
> > 
> > I like this approach better than mine now that I understand it.  I've
> > tested the patch below without any changes.  It works as expected with
> > my previous test case.  I don't know if a Signed-off-by: is appropriate
> > for me in this case, but I'll throw in a:
> > 
> > Tested-by: Richard Guy Briggs <rbriggs@redhat.com>
> > 
> > and recommend a:
> > 
> > Reported-By: Steve Grubb <sbrubb@redhat.com>
> 
> If this is the approved patch, can it be put in stable? The audit system 
> hasn't worked as intended since January.

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/auditsc.c?id=780a7654cee8d61819512385e778e4827db4bfbc

Should be queued for 3.7 and later now.

