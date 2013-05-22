Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3EVRe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:34:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53479 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3EVReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:34:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: viro@zeniv.linux.org.uk, serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bfields@fieldses.org,
        bharrosh@panasas.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, devel@openvz.org
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
Date: Wed, 22 May 2013 10:33:52 -0700
In-Reply-To: <20130522072840.27720.85023.stgit@localhost.localdomain>
	(Stanislav Kinsbursky's message of "Wed, 22 May 2013 11:29:18 +0400")
Message-ID: <878v36ex6n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18oEQw/K6QRvGWvosEN7Igosjd7pojeZ9o=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0062]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> Usermode helper executes all binaries in global "init" root context. This
> doesn't allow to call a binary from other root context (for example in a
> container).
> Currently, both containerized NFS client and NFS server requires an ability to
> execute a binary in a container's root context. Root swap can be done in
> "init" callback, passed by UMH caller.
> But since we have 2 callers already (and more of them are expected to appear
> in future) and because set_fs_root() in not exported, it looks reasonable to
> add one more generic UMH helper to generic fs code.
> Root path reference must be hold by the caller, since it will be put on UMH
> thread exit.

Awesome.  With this patch as an uprivilieged user I get to pick which
binary the kernel will execute.  At least if nfs and nfsd ever runs in a
user namespace (something that looks like only matter of time).

I think this is a seriously bad idea.

Why can't we do this in userspace with setns as we do with the core dump
helper?

I am missing a lot of context here and capturing the context of a
process at time time we mount the filesystem and reconstituing it in
call user mode helper seems like something we could do.

This patch as it stands looks like it would compete for the honor of the
easiest kernel feature to exploit.

Eric
