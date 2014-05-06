Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaEFDdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:33:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaEFDdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:33:13 -0400
Date: Tue, 6 May 2014 03:33:08 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
Message-ID: <20140506033308.GE6508@ubuntumail>
References: <cover.1398176489.git.rgb@redhat.com>
 <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
 <20140505214424.GB6867@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505214424.GB6867@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> On 14/05/03, James Bottomley wrote:
> > On Tue, 2014-04-22 at 14:12 -0400, Richard Guy Briggs wrote:
> > > Questions:
> > > Is there a way to link serial numbers of namespaces involved in migration of a
> > > container to another kernel?  (I had a brief look at CRIU.)  Is there a unique
> > > identifier for each running instance of a kernel?  Or at least some identifier
> > > within the container migration realm?
> > 
> > Are you asking for a way of distinguishing an migrated container from an
> > unmigrated one?  The answer is pretty much "no" because the job of
> > migration is to restore to the same state as much as possible.
> 
> I hadn't thought to distinguish a migrated container from an unmigrated
> one, but rather I'm more interested in the underlying namespaces.  The
> use of a generation number to identify a migrated namespace may be
> useful along with the logging to tie them together.
> 
> > Reading between the lines, I think your goal is to correlate audit
> > information across a container migration, right?  Ideally the management
> > system should be able to cough up an audit trail for a container
> > wherever it's running and however many times it's been migrated?
> 
> The original intent was to track the underlying namespaces themselves.
> This sounds like another layer on top of that which sounds useful but
> that I had not yet considered.
> 
> But yes, that sounds like a good eventual goal.

Right and we don't need that now, all *I* wanted to convince myself of
was that a serial # as you were using it was not going to be a roadlbock
to that, since once we introduce a serial #, we're stuck with that as
user-space facing api.

> > In that case, I think your idea of a numeric serial number in a dense
> > range is wrong.  Because the range is dense you're obviously never going
> > to be able to use the same serial number across a migration.  However,
> > if you look at all the management systems for containers, they all have
> > a concept of some unique ID per container, be it name, UUID or even
> > GUID.  I suspect it's that you should be using to tag the audit trail
> > with.
> 
> That does sound potentially useful but for the fact that several
> containers could share one or more types of namespaces.
> 
> Would logging just a container ID be sufficient for audit purposes?  I'm
> going to have to dig a bit to understand that one because I was unaware
> each container had a unique ID.

They don't :)

> I did originally consider a UUID/GUID for namespaces.

So I think that apart from resending to address the serial # overflow
comment, I'm happy to ack the patches.  Then we probably need to convicne
Eric that we're not torturing kittens.

-serge
