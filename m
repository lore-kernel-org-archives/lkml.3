Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab3BKSw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:52:27 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41116 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab3BKSwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:52:23 -0500
Date: Mon, 11 Feb 2013 18:52:39 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the
 hierarchy
Message-ID: <20130211185239.GA18779@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209040402.GA31942@mail.hallyn.com>
 <20130211143241.GF30962@redhat.com>
 <20130211174259.GA18179@mail.hallyn.com>
 <20130211183847.GG30962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211183847.GG30962@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> On Mon, Feb 11, 2013 at 05:42:59PM +0000, Serge E. Hallyn wrote:
> > Note I said only forbid behavior changes - not exception changes - to
> > cgroups with children.
> 
> that won't do much. behavior change is the simplest: if you change a
> behavior, you wipe the local exceptions unless the special (deny, deny)
> -> (allow, deny) case.

Right but that is what has the most non-sensical implications for
propagation.

> exception propagation is harder

But if we removed behavior change propagation, then your exception
propagation not only would be correct, it could be simplified by
removing the .local stuff altogether.  Local would be obvious:
if it's in current and not in parent, it's local.  Or when adding
a new exception e2, if exception e1 is in current and not in parent
minus the new exception e2, then e1 is local.

> getting rid of local settings would buy more simplicity

(Not sure which you mean here by 'getting rid of local settings')

-serge
