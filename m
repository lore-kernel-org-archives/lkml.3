Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLRTZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLRTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:25:05 -0500
Date: Thu, 18 Dec 2014 14:24:58 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
Message-ID: <20141218192458.GG29998@madcap2.tricolour.ca>
References: <2966.1418778594@turing-police.cc.vt.edu>
 <5444.1418921116@turing-police.cc.vt.edu>
 <1418921420.5162.19.camel@localhost>
 <8832.1418930473@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8832.1418930473@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/18, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 18 Dec 2014 11:50:20 -0500, Eric Paris said:
> > On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> > > > Spotted these two while booting single-user on 20141216.  20141208
> > > > doesn't throw these, so it's something in the last week or so..
> > >
> > > Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> > > just fine for several days, but it went around the bend, apparently due
> > > to a userspace or initrd change.
> >
> > $5 says you updated systemd?
> 
> Actually, yeah.  yum.log says:
> 
> Dec 12 14:08:09 Updated: systemd-218-1.fc22.x86_64
> 
> and things started going downhill that evening.  Damned if I know what 218
> was doing to cause the issues.  (Other RPM update that looked vaguely
> related was for selinux-policy, but again, damned if I know what a policy
> file could contain that would change the behavior...)
> 
> Is it worth backing it to -217, or do we have a handle on the issue and
> systemd is just the messenger?

I've got a potential fix since the problem looks pretty obvious now.

This is stable branch material...

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
