Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAZQWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:22:30 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:42821
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561AbaAZQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:22:29 -0500
Date: Sun, 26 Jan 2014 17:22:28 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aaron Jones <aaronmdjones@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: File capabilities are not 'working' and I have no idea why
Message-ID: <20140126162228.GA6946@mail.hallyn.com>
References: <52DE7557.3000500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE7557.3000500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aaron Jones (aaronmdjones@gmail.com):
> 
> Hello.
> 
> I recently upgraded from 3.10.7 on a long-running box to 3.12.8 on a
> new box. I have been using file capabilities for a long time, so that
> processes do not need to start as root and drop unnecessary privileges
> later.
> 
> For example, there is no reason for my bind9 nameservers to start as
> root, except to bind() port 53 and 953. What I did in this case was to
> chown it to root:named and chmod it to 0750 and assign
> CAP_NET_BIND_SERVICE to it, it then starts as named and works fine.
> 
> I haven't had any issues with this for easily a year, until now. No
> matter what I do on this new machine, I cannot get file capabilities
> to 'work'. They are set fine, they are read back fine, but they don't
> do anything. I have attached my kernel boot log, its configuration and
> a test program (build with -std=c99 -lcap-ng).
> 
> My problem follows:
> 
> # strace -f setcap cap_net_bind_service+eip /usr/local/bin/caps 2>&1 \
>   | grep xattr
>  setxattr("/usr/local/bin/caps", "security.capability", \
>   "\x01\x00\x00\x02\x00\x04\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00 \
>    \x00\x00\x00\x00", 20, 0) = 0
> 
> # getcap /usr/local/bin/caps
> /usr/local/bin/caps = cap_net_bind_service+eip
> 
> $ /usr/local/bin/caps
> Effective capabilities: (none)
> Permitted capabilities: (none)

Hm, I'm running Ubuntu 3.13.0-5-generic and I do get

serge@tp:~/test$ ./caps
Effective capabilities:
net_bind_service

Permitted capabilities:
net_bind_service

Any chance (grasping for straws here) that the hardening patches are
interfering?  Can you try hand-building an upstream kernel to test
with?

-serge
