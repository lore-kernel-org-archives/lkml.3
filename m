Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3KSXBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:01:19 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:34254 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3KSXBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:01:18 -0500
From: Paul Moore <paul@paul-moore.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH linux-next] SELinux: security_load_policy: Silence frame-larger-than warning
Date: Tue, 19 Nov 2013 18:01:11 -0500
Message-ID: <2654507.D28U1bHoel@sifl>
User-Agent: KMail/4.11.2 (Linux/3.12.0-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <528BEA34.9060907@canonical.com>
References: <1384466691-42392-1-git-send-email-tim.gardner@canonical.com> <2344755.pvM4VQSB59@sifl> <528BEA34.9060907@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 19, 2013 02:46:12 PM Tim Gardner wrote:
> On 11/19/2013 02:38 PM, Paul Moore wrote:
> > On Thursday, November 14, 2013 03:04:51 PM Tim Gardner wrote:
> >> Dynamically allocate a couple of the larger stack variables in order to
> >> reduce the stack footprint below 1024. gcc-4.8
> >> 
> >> security/selinux/ss/services.c: In function 'security_load_policy':
> >> security/selinux/ss/services.c:1964:1: warning: the frame size of 1104
> >> bytes is larger than 1024 bytes [-Wframe-larger-than=] }
> >> 
> >> Also silence a couple of checkpatch warnings at the same time.
> >> 
> >> WARNING: sizeof policydb should be sizeof(policydb)
> >> +	memcpy(oldpolicydb, &policydb, sizeof policydb);
> >> 
> >> WARNING: sizeof policydb should be sizeof(policydb)
> >> +	memcpy(&policydb, newpolicydb, sizeof policydb);
> >> 
> >> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> >> Cc: James Morris <james.l.morris@oracle.com>
> >> Cc: Eric Paris <eparis@parisplace.org>
> >> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >> ---
> >> 
> >>  security/selinux/ss/services.c |   54
> >>  ++++++++++++++++++++++--------------
> >>  1 file changed, 32 insertions(+), 22 deletions(-)
> > 
> > Applied, thanks.  It will be pushed to my next tree once -rc1 is released.
> > 
> > In the future, please send SELinux patches to the SELinux mailing list.
> 
> It is difficult to know where to send a patch for every subsystem. I've
> been using the get_maintainer.pl script, so perhaps the info in
> MAINTAINERS is stale ? I'm open to suggestions.

The SELinux mailing list information in the MAINTAINERS file isn't stale, 
although we have just recently changed the tree location and that patch hasn't 
hit Linus' tree yet.  Here is the most current snippet:

 SELINUX SECURITY MODULE
 M:      Stephen Smalley <sds@tycho.nsa.gov>
 M:      James Morris <james.l.morris@oracle.com>
 M:      Eric Paris <eparis@parisplace.org>
 M:      Paul Moore <paul@paul-moore.com>
 L:      selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:      http://selinuxproject.org
 T:      git git://git.infradead.org/users/pcmoore/selinux
 S:      Supported
 F:      include/linux/selinux*
 F:      security/selinux/
 F:      scripts/selinux/

My Perl is a bit rusty/non-existent so I'm not sure why the get_maintainer 
script isn't showing the mailing list information, so in the meantime I would 
suggest just looking through the file by hand.
 
> $: scripts/get_maintainer.pl -f security/selinux/ss/services.c
> Stephen Smalley <sds@tycho.nsa.gov> (supporter:SELINUX SECURITY...)
> James Morris <james.l.morris@oracle.com> (supporter:SELINUX SECURITY...)
> Eric Paris <eparis@parisplace.org> (supporter:SELINUX SECURITY...)
> linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
> linux-kernel@vger.kernel.org (open list)
> 
> rtg

-- 
paul moore
www.paul-moore.com

