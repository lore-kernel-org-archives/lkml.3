Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaHUWdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbaHUWdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:33:00 -0400
Date: Thu, 21 Aug 2014 18:32:52 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com,
        serge@hallyn.com
Subject: Re: [PATCH V4 0/8] namespaces: log namespaces per task
Message-ID: <20140821223252.GF20529@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com>
 <20140821200555.GK5620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821200555.GK5620@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/21, Aristeu Rozanski wrote:
> Hi Richard,

Hi Aris,

> On Wed, Aug 20, 2014 at 09:09:33PM -0400, Richard Guy Briggs wrote:
> > Is there a way to link serial numbers of namespaces involved in migration of a
> > container to another kernel?  It sounds like what is needed is a part of a
> > mangement application that is able to pull the audit records from constituent
> > hosts to build an audit trail of a container.
> 
> since you're introducing a brand new serial number to make it unique
> across different procfs mounts, why not instead of a simple counter,
> use the hash output of say, $hostname-$creation_time-$random?

I had thought of this earlier on, but I could see many VMs started up
from an identical image, making the resulting hash possibly identical.

Besides, hostname isn't known yet when we are creating initial
namespaces.

> Or perhaps
> get a short hash of the hostname (generated once whenever hostname is
> set) and append the serial number you're implementing? It'd be way less human
> readable than your current proposal but it'd be unique "globally" (as long you
> don't have machines with the same hostname migrating containers between them),
> allowing the migrated namespaces to retain their unique identification across
> audit logs. It'd of course be way more costly than just using an atomic counter,
> but could be useful to anything that needs to refer to a namespace and could be
> migrated to another machine.

This also means that any namespace that is migrated would have to be
recreated on another host and inject an existing ID into it rather than
have the host creating it generate that ID.  Some namespaces are peers
that take the kernel default, while others are hierarchical and inherit
from their creating namespaces.

It was much easier at my layer to punt that management to a higher
layer that already knew about the other hosts in play and to manage that
information as it saw fit.

> What you think? Sounds too crazy? :)

Yup.  I was hoping there would be some kind of unique identifier per
running kernel, including CPU_ID (which may not exist or may be shut
off), RTC boot value (which may be identical for VMs), or initial random
state (which could be identical for VMs).

> Aristeu

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
