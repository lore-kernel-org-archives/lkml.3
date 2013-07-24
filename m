Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3GXPaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:30:23 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:47874
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390Ab3GXPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:30:19 -0400
Date: Wed, 24 Jul 2013 15:30:18 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [REVIEW][PATCH] vfs: Lock in place mounts from more privileged
 users
Message-ID: <20130724153018.GA17960@mail.hallyn.com>
References: <877gghruwq.fsf@xmission.com>
 <CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
 <87li4wpi2b.fsf@xmission.com>
 <20130724124933.GA16517@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724124933.GA16517@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > 
> > Serge does this patch break lxc?  I think all should be well but I want
> > to make certain there is not some hidden case where this fundamentaly
> > breaks some functionality.
> 
> I haven't yet tried.  I'll build and test a kernel today.  I'm pretty
> sure all the child's mounts are done after clone, so I *think* the worst
> case will be that the unmounting of put_old after pivot_root() will
> be noisy.  Will let you know.
> 
> -serge

Just tested it - works fine.  Warns about all of the failed umounts.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

( Mind you I'm not approving of the idea of hiding mounts as a security
mechanisms, but I know that neither are you :)

thanks,
-serge
