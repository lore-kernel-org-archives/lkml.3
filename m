Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaK0OVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:21:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaK0OVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:21:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <12076.1417097856@warthog.procyon.org.uk>
References: <12076.1417097856@warthog.procyon.org.uk> <545A6464.5070702@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154318.2555.7052.stgit@warthog.procyon.org.uk> <545A53A9.4060009@tycho.nsa.gov>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] SELinux: The copy-up operation must have read permission on the lower file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12172.1417098096.1@warthog.procyon.org.uk>
Date: Thu, 27 Nov 2014 14:21:36 +0000
Message-ID: <12173.1417098096@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > This means that it expects to trigger those capability checks as part of
> > its subsequent actions.  Raising those capabilities temporarily in its
> > credentials will pass the capability module checks but won't address the
> > corresponding SELinux checks (both capability and file-based), so you'll
> > end up triggering an entire set of checks against the current process'
> > credentials.  This same pattern is repeated elsewhere in overlayfs.
> 
> Hmmm...  Yes.  I need to check whether the lower file can be read *before*
> overriding the creds.

Actually, I think ovl_permission() does sufficient checks on the lower inode
by calling __inode_permission() upon it.

David
