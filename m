Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaJFMrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaJFMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:47:08 -0400
Date: Mon, 6 Oct 2014 08:47:02 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
Cc: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "pmoore@redhat.com" <pmoore@redhat.com>,
        "aviro@redhat.com" <aviro@redhat.com>,
        "sgrubb@redhat.com" <sgrubb@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
Message-ID: <20141006124702.GW1992@madcap2.tricolour.ca>
References: <cover.1412543112.git.rgb@redhat.com>
 <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
 <5871495633F38949900D2BF2DC04883E5DABA4@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E5DABA4@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/06, Chen, Hanxiao wrote:
> 
> 
> > -----Original Message-----
> > From: containers-bounces@lists.linux-foundation.org
> > [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Richard Guy
> > Briggs
> > Sent: Monday, October 06, 2014 1:09 PM
> > To: linux-audit@redhat.com; linux-kernel@vger.kernel.org;
> > containers@lists.linux-foundation.org
> > Cc: eparis@redhat.com; pmoore@redhat.com; aviro@redhat.com; sgrubb@redhat.com;
> > ebiederm@xmission.com
> > Subject: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
> > 
> > ---
> >  include/uapi/linux/sched.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> > index 34f9d73..5aceba2 100644
> > --- a/include/uapi/linux/sched.h
> > +++ b/include/uapi/linux/sched.h
> > @@ -28,6 +28,12 @@
> >  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
> >  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
> >  #define CLONE_NEWNET		0x40000000	/* New network namespace */
> > +#define CLONE_NEW_MASK	( CLONE_NEWNS \
> > +			| CLONE_NEWUTS \
> > +			| CLONE_NEWIPC \
> > +			| CLONE_NEWUSER \
> > +			| CLONE_NEWPID \
> > +			| CLONE_NEWNET)	/* mask of all namespace type flags */
> >  #define CLONE_IO		0x80000000	/* Clone io context */
> 
> The name 'CLONE_NEW_MASK' may confuse readers.
> How about something like CLONE_NEW_MASK_ALL?

Fair enough.  Changed.

> Thanks,
> - Chen

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
