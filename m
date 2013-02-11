Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901Ab3BKUrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:47:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab3BKUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:47:37 -0500
Date: Mon, 11 Feb 2013 14:47:29 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130211204729.GA12224@sergelap>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209040402.GA31942@mail.hallyn.com>
 <20130211143241.GF30962@redhat.com>
 <20130211174259.GA18179@mail.hallyn.com>
 <20130211183847.GG30962@redhat.com>
 <20130211185239.GA18779@mail.hallyn.com>
 <20130211190251.GH30962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211190251.GH30962@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> On Mon, Feb 11, 2013 at 06:52:39PM +0000, Serge E. Hallyn wrote:
> > > getting rid of local settings would buy more simplicity
> > 
> > (Not sure which you mean here by 'getting rid of local settings')
> 
> no local.{behavior,exceptions}, which still would allow behavior
> propagation, but simply wouldn't keep local behavior or exceptions.
> a change in behavior on parent would simply reset the child to parent's

Why would that be necessary?  If I add permission to the parent, I just
don't propagate it.  If I remove permission from the parent, I make sure
all children don't have that permission, but keep everything else.
The child's permission is never allowed to exceed its parent's.

We don't need to reset the child's to the parent's.

> state. exception propagation would mean inserting/removing the new
> exception and making sure the others are still valid.
> 
> -- 
> Aristeu
> 
