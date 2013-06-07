Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3FGM6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:58:55 -0400
Received: from cdw.me.uk ([91.203.57.136]:36480 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab3FGM6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:58:54 -0400
Date: Fri, 7 Jun 2013 13:58:49 +0100
From: Chris Webb <chris@arachsys.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building a BSD-jail clone out of namespaces
Message-ID: <20130607125848.GG24681@arachsys.com>
References: <20130606215150.GG17158@arachsys.com>
 <87a9n24lan.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9n24lan.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> It is a wider issue. Capabilities cover most of places in the kernel
> where the kernel tests if you have privilege but there are other
> filesystems like devtmpsfs, and the occasional silly piece of kernel
> code that should be using capabilities but is not.  Beyond the kernel
> there are files like /etc/shadow that only root is allowed to read.
> 
> Which all boils down to the fact that for the inconvience of using a
> separate range of uids a lot of other problems just go away.

Hi. Thanks for the clarifications here, which make a lot of sense.

> Not being able to share the host filesystem into a container is a
> downside of the current implementation.  In principle you can have an
> overlay style filesystem that munges the uids and removes this
> limitation, but that doesn't currently exist.

Yes, given the design means I can't just have an identity UID/GID mapping,
this seems like the building block I'm missing to get namespace IDs instead
of host IDs stored on disk. I imagine it might be fairly straightforward for
me to take a simple 'example' stacked filesystem like wrapfs and teach it to
map UIDs and GIDs. I'll have to take a look.

Cheers,

Chris.
