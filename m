Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbaDBRcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:32:51 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:38934
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932387AbaDBRcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:32:50 -0400
Date: Wed, 2 Apr 2014 19:32:49 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sean Pajot <sean.pajot@execulink.com>,
        lxc-devel@lists.linuxcontainers.org, linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
Message-ID: <20140402173248.GA22804@mail.hallyn.com>
References: <5266BEA3.6020008@execulink.com>
 <20131022193718.GA18463@ac100>
 <874n89rsoc.fsf@xmission.com>
 <20140402172049.GA13240@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402172049.GA13240@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry - the lxc-devel list has moved, so replying to all with the
correct list address;   please reply to this rather than my previous
email)

Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
> Hi Eric,
> 
> (sorry, I don't seem to have the email I actually wanted to reply
> to in my mbox, but it is
> https://lists.linuxcontainers.org/pipermail/lxc-devel/2013-October/005857.html)
> 
> You'd said,
> > Someone needs to read and think through all of the corner cases and see
> > if we can ever have a time when task_dumpable is false but root in the
> > container would not or should not be able to see everything.
> > 
> > In particular I am worried about the case of a setuid app calling setns,
> > and entering a lesser privileged user namespace.  In my foggy mind that
> > might be a security problem.  And there might be other similar crazy
> > cases.
> 
> Can we make use of current->mm->exe_file->f_cred->user_ns?
> 
> So either always use 
> make_kgid(current->mm->exe_file->f_cred->user_ns, 0)
> instead of make_kuid(cred->user_ns, 0), or check that
> (current->mm->exe_file->f_cred->user_ns == cred->user_ns)
> and, if not, assume that the caller has done a setns?
> 
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
