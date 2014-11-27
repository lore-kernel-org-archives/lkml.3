Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaK0RZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:25:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaK0RZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:25:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <545A51CB.6070107@tycho.nsa.gov>
References: <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16215.1417109138.1@warthog.procyon.org.uk>
Date: Thu, 27 Nov 2014 17:25:38 +0000
Message-ID: <16216.1417109138@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Also, would be good to create a common helper for use here, by
> selinux_dentry_init_security(), selinux_inode_init_security(), and
> may_create().  Already some seeming potential for inconsistencies there.

selinux_dentry_init_security() and selinux_inode_init_security() do something
different depending on SECURITY_FS_USE_MNTPOINT.  Is the dentry variant wrong?
Shouldn't it be using the mountpoint label if that flag _is_ set?

David
