Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaDBRVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:21:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaDBRVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:21:03 -0400
Date: Wed, 2 Apr 2014 12:20:49 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sean Pajot <sean.pajot@execulink.com>, lxc-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
Message-ID: <20140402172049.GA13240@sergelap>
References: <5266BEA3.6020008@execulink.com>
 <20131022193718.GA18463@ac100>
 <874n89rsoc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n89rsoc.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

(sorry, I don't seem to have the email I actually wanted to reply
to in my mbox, but it is
https://lists.linuxcontainers.org/pipermail/lxc-devel/2013-October/005857.html)

You'd said,
> Someone needs to read and think through all of the corner cases and see
> if we can ever have a time when task_dumpable is false but root in the
> container would not or should not be able to see everything.
> 
> In particular I am worried about the case of a setuid app calling setns,
> and entering a lesser privileged user namespace.  In my foggy mind that
> might be a security problem.  And there might be other similar crazy
> cases.

Can we make use of current->mm->exe_file->f_cred->user_ns?

So either always use 
make_kgid(current->mm->exe_file->f_cred->user_ns, 0)
instead of make_kuid(cred->user_ns, 0), or check that
(current->mm->exe_file->f_cred->user_ns == cred->user_ns)
and, if not, assume that the caller has done a setns?

-serge
