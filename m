Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab3LIS00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:26:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3LIS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:26:24 -0500
Date: Mon, 9 Dec 2013 12:26:19 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
Message-ID: <20131209182619.GD6849@sergelap>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
 <529EE877.7030701@cn.fujitsu.com>
 <20131206221241.GD22445@mail.hallyn.com>
 <52A52599.3070502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A52599.3070502@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> On 12/07/2013 06:12 AM, Serge E. Hallyn wrote:
> > Quoting Gao feng (gaofeng@cn.fujitsu.com):
> >> Hi
> >>
> >> On 10/24/2013 03:31 PM, Gao feng wrote:
> >>> Here is the v1 patchset: http://lwn.net/Articles/549546/
> >>>
> >>> The main target of this patchset is allowing user in audit
> >>> namespace to generate the USER_MSG type of audit message,
> >>> some userspace tools need to generate audit message, or
> >>> these tools will broken.
> >>>
> >>
> >> I really need this feature, right now,some process such as
> >> logind are broken in container becase we leak of this feature.
> > 
> > Your set doesn't address loginuid though right?  How exactly do you
> > expect to do that?  If user violates MAC policy and audit msg is
> > sent to init user ns by mac subsys, you need the loginuid from
> > init_audit_ns.  where will that be stored if you allow updates
> > of loginuid in auditns?
> > 
> This patchset doesn't include the loginuid part.
> 
> the loginuid is stored in task as before.
> In my opinion, when task creates a new audit namespace, this task's
> loginuid will be reset to zero, so the children tasks can set their
> loginuid. Does this change break the MAC?

I think so, yes.  In an LSPP selinux environment, if the task
manages to trigger an selinux deny rule which is audited, then
the loginuid must make sense on the host.  Now presumably it
will get translated to the mapped host uid, and we can figure
out the host uid owning it through /etc/subuid.  But that adds
/etc/subuid as a new part of the TCB without any warning <shrug>
So in that sense, for LSPP, it breaks it.

-serge
