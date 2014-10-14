Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaJNO0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbaJNO0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:26:04 -0400
Date: Tue, 14 Oct 2014 10:25:53 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        sgrubb@redhat.com, aviro@redhat.com, pmoore@redhat.com,
        arozansk@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH V5 13/13] Documentation: add a section for /proc/<pid>/ns/
Message-ID: <20141014142553.GE2966@madcap2.tricolour.ca>
References: <cover.1412543112.git.rgb@redhat.com>
 <982503bc4e4c24cbdebd111b27191ed5bee75572.1412543112.git.rgb@redhat.com>
 <20141013134659.GL24703@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013134659.GL24703@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/13, Serge E. Hallyn wrote:
> Quoting Richard Guy Briggs (rgb@redhat.com):
> > ---
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> (some nitpicking below)
> 
> Thanks, Richard.  IMO this patchset is great at the moment.  Now if I
> checkpoint a container, migrate it to another machine, and restart it
> there, the serial numbers will no longer match, but as the creations are
> all logged, userspace can track the changed snum, so I don't believe
> that is a problem.  (Pretty sure we've discussed that before, mostly
> mentioning it here to think through it myself)

In fact, these last two are included for completeness, but deprecated,
since as has been pointed out it is visible from inside the container.
I am expecting to drop the last two patches since the necessary
information is available to the audit logs in previous patches, which
can be made available to docker or other container supervisor.

> >  Documentation/filesystems/proc.txt |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> > index ddc531a..c4bfd6f 100644
> > --- a/Documentation/filesystems/proc.txt
> > +++ b/Documentation/filesystems/proc.txt
> > @@ -42,6 +42,7 @@ Table of Contents
> >    3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
> >    3.7   /proc/<pid>/task/<tid>/children - Information about task children
> >    3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
> > +  3.9   /proc/<pid>/ns/<ns>{,_snum} - Information about process namespaces
> >  
> >    4	Configuring procfs
> >    4.1	Mount options
> > @@ -1744,6 +1745,21 @@ pair provide additional information particular to the objects they represent.
> >  	optional and may be omitted if no marks created yet.
> >  
> >  
> > +3.9	/proc/<pid>/ns/<nstype>{,_snum} - Information about process namespaces
> > +--------------------------------------------------------------------------
> > +These files provides information about the namespaces within which the process
> 
> s/provides/provide/
> 
> > +is contained.  The files named only with the namespace type <nstype> contain a
> > +link that lists the containing namespace' inode number in its proc filesystem.
> 
> s/'/'s/
> 
> ... Maybe add "And which can be used with setns(2)."
> 
> > +The files with suffix _snum contain a link that lists the containing
> > +namespace' instance serial number, unique per kernel since boot.  The
> 
> s/'/'s/
> 
> > +namespace types are self-describing.
> > +
> > +The output format of the inode links is:
> > +	<nstype>:[<inode_number>]
> > +The output format of the serial number links is:
> > +	<nstype>_snum:[<serial_number>]
> > +
> > +
> >  ------------------------------------------------------------------------------
> >  Configuring procfs
> >  ------------------------------------------------------------------------------
> > -- 
> > 1.7.1

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
