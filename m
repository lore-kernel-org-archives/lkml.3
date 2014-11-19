Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaKSIvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:51:00 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:38020 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaKSIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:50:58 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141118152156.GA21726@ubuntu-mba51>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
	<1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
	<20141111140454.GD333@tucsk>
	<87mw7xd9zt.fsf@x220.int.ebiederm.org>
	<20141112130915.GG333@tucsk>
	<20141112162254.GB31775@ubuntu-hedt>
	<20141118152156.GA21726@ubuntu-mba51>
Date: Wed, 19 Nov 2014 09:50:57 +0100
Message-ID: <CAJfpeguuT1V1Pf0iFXRozmeohDH2Jy=p8o=1EnvD_qfB1CTQuA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 4:21 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
>> I asked around a bit, and it turns out there are use cases for nested
> containers (i.e. a container within a container) where the rootfs for
> the outer container mounts a filesystem containing the rootfs for the
> inner container. If that mount is nosuid then suid utilities like ping
> aren't going to work in the inner container.
>
> So since there's a use case for suid in a userns mount and we have what
> we belive are sufficient protections against using this as a vector to
> get privileges outside the container, I'm planning to move ahead without
> the MNT_NOSUID restriction. Any objections?

In the general case how'd we prevent suid executable being tricked to
do something it shouldn't do by unprivileged mounting into sensitive
places (i.e. config files) inside the container?

Allowing SUID looks like a slippery slope to me.  And there are plenty
of solutions to the "ping" problem, AFAICS, that don't involve the
suid bit.

Disclaimer: I'm pretty ignorant in the field of computer security...

Thanks,
Miklos
