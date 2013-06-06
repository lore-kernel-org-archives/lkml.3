Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3FFQq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:46:56 -0400
Received: from cdw.me.uk ([91.203.57.136]:46588 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3FFQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:46:54 -0400
Date: Thu, 6 Jun 2013 17:46:52 +0100
From: Chris Webb <chris@arachsys.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building a BSD-jail clone out of namespaces
Message-ID: <20130606164651.GA24681@arachsys.com>
References: <20130606161010.GI12062@arachsys.com>
 <87ehcf8aef.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehcf8aef.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> That will work, but you really don't want to run with uid == 0 mapped to
> uid == 0.  There are too many things in /proc and /sys and similar that
> grant access to uid == 0.

Many thanks for the swift reply. If I map UID zero in the userns to a
non-zero UID outside (say -1), is there any way to use the userns UIDs
instead of host UIDs when accessing the container's root filesystem so I
don't end up with strange file ownerships on disk? This would prevent me
from using the same filesystem on physical hosts or in VMs.

I don't think there's any kernel mechanism that lets me apply a UID
translation layer as part of a bind mount is there?

Cheers,

Chris.
