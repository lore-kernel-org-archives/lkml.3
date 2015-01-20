Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbbATXSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:18:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:38687 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbATXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:18:09 -0500
Date: Wed, 21 Jan 2015 10:17:29 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Ben Hutchings <ben@decadent.org.uk>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, 770492@bugs.debian.org,
        Ben Harris <bjh21@cam.ac.uk>, oss-security@lists.openwall.com,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH RESEND] vfs: Move security_inode_killpriv() after
 permission checks
In-Reply-To: <1421537206.31046.74.camel@decadent.org.uk>
Message-ID: <alpine.LRH.2.11.1501211014580.15885@namei.org>
References: <1421537206.31046.74.camel@decadent.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2015, Ben Hutchings wrote:

> chown() and write() should clear all privilege attributes on
> a file - setuid, setgid, setcap and any other extended
> privilege attributes.
> 
> However, any attributes beyond setuid and setgid are managed by the
> LSM and not directly by the filesystem, so they cannot be set along
> with the other attributes.
> 
> Currently we call security_inode_killpriv() in notify_change(),
> but in case of a chown() this is too early - we have not called
> inode_change_ok() or made any filesystem-specific permission/sanity
> checks.
> 
> Add a new function setattr_killpriv() which calls
> security_inode_killpriv() if necessary, and change the setattr()
> implementation to call this in each filesystem that supports xattrs.
> This assumes that extended privilege attributes are always stored in
> xattrs.

It'd be useful to get some input from LSM module maintainers on this. 

e.g. doesn't SELinux already handle this via policy directives?


-- 
James Morris
<jmorris@namei.org>

