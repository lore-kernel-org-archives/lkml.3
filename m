Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaK2QHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:07:05 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:59733 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2QHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:07:02 -0500
Date: Sat, 29 Nov 2014 19:06:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Message-ID: <20141129160659.GA2256@moon>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:05:01PM -0800, Andy Lutomirski wrote:
> Pid reuse is common, which means that it's difficult or impossible
> to read information about a pid from /proc without races.
> 
> This introduces a second number associated with each (task, pidns)
> pair called highpid.  Highpid is a 64-bit number, and, barring
> extremely unlikely circumstances or outright error, a (highpid, pid)
> will never be reused.
> 
> With just this change, a program can open /proc/PID/status, read the
> "Highpid" field, and confirm that it has the expected value.  If the
> pid has been reused, then highpid will be different.
> 
> The initial implementation is straightforward: highpid is simply a
> 64-bit counter. If a high-end system can fork every 3 ns (which
> would be amazing, given that just allocating a pid requires at
> atomic operation), it would take well over 1000 years for highpid to
> wrap.
> 
> For CRIU's benefit, the next highpid can be set by a privileged
> user.
> 
> NB: The sysctl stuff only works on 64-bit systems.  If the approach
> looks good, I'll fix that somehow.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> If this goes in, there's plenty of room to add new interfaces to
> make this more useful.  For example, we could add a fancier tgkill
> that adds and validates hightgid and highpid, and we might want to
> add a syscall to read one's own hightgid and highpid.  These would
> be quite useful for pidfiles.
> 
> David, would this be useful for kdbus?
> 
> CRIU people: will this be unduly difficult to support in CRIU?

Hi Andy. I think it won't be hard to support.
