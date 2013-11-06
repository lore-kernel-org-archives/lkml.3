Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3KFSBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:01:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3KFSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:01:53 -0500
Date: Wed, 6 Nov 2013 12:02:32 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Oleg Nesterov <oleg@redhat.com>, Christian Seiler <christian@iwakd.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106180232.GA8980@ac100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
"fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
breaks lxc-attach in 3.12.  That code forks a child which does
setns() and then does a clone(CLONE_PARENT).  That way the
grandchild can be in the right namespaces (which the child was
not) and be a child of the original task, which is the monitor.

lxc-attach in 3.11 was working fine with no side effects that I
could see.  Is there a real danger in allowing CLONE_PARENT
when current->nsproxy->pidns_for_children is not our pidns,
or was this done out of an "over-abundance of caution"?  Can we
safely revert that new extra check?

thanks,
-serge
