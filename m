Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaGSIz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:55:26 -0400
Received: from imap.thunk.org ([74.207.234.97]:44856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbaGSIzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:55:23 -0400
Date: Sat, 19 Jul 2014 02:16:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>
Subject: Re: [PULL] seccomp update (3.17)
Message-ID: <20140719061658.GK18775@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@amacapital.net>,
	Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
	Julien Tinnes <jln@chromium.org>,
	David Drysdale <drysdale@google.com>
References: <20140718191908.GA20534@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718191908.GA20534@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:19:08PM -0700, Kees Cook wrote:
> Hi James,
> 
> Please pull these seccomp changes for 3.17.
> 
> (And if I should base off something other than security-next, please
> let me know. Or if there are any things I should be doing differently
> with this tree.)

One note; there is a (interim) syscall number collision with the new
getrandom(2) system call.  I'm sure Linus will be able to handle it,
and fix it up, but I just wanted to give a heads up that depending on
which pull request hits mainline first, the syscall number for either
the new seccomp(2) or getrandom(2) may end up changing.

I've been warning people not to try to use getrandom(2) or check
anything into LibreSSL, et. al., until the patch is finalized and in
Linus's tree, but if you have userspace users already using the
syscall assignments in this patch series, please let me know and I can
try to make adjustments on my side.

Cheers,

    		      		       	   - Ted
