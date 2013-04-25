Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3DYPHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:07:08 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:44290 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab3DYPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:07:06 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: John Johansen <john.johansen@canonical.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
Date: Thu, 25 Apr 2013 11:01:50 -0400
Message-ID: <47138397.PP25Tg7m1s@sifl>
User-Agent: KMail/4.10.2 (Linux/3.8.5-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51787C1C.1040301@schaufler-ca.com>
References: <5176ABB7.5080300@schaufler-ca.com> <517863F8.7050606@canonical.com> <51787C1C.1040301@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 24, 2013 05:43:08 PM Casey Schaufler wrote:
> On 4/24/2013 4:00 PM, John Johansen wrote:
> > On 04/24/2013 02:15 PM, Paul Moore wrote:
> >> On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:

...

> >>> An interesting aside that may be relevant is that the error
> >>> condition behavior makes it advisable to have the LSM you care
> >>> about most go last. If the networking components were strictly
> >>> FCFS you might have to chose an ordering you might not want for
> >>> other reasons.
> >> 
> >> Well, maybe not ... I think.  If we take a FCFS approach to the network
> >> controls then only one LSM is really ever going to throw an error on the
> >> network hooks, yes?
> 
> You set up the order you want to get the networking handled
> correctly and you could get filesystem hooks in the wrong order.
> Not that that really ought to be a problem, but there are wonky
> admin tools out there.

I don't quite follow; can you be a bit more explicit about getting the 
filesystem hooks in the wrong order?

> >> I'm still in favor of assigning the network hooks to the LSM at boot
> >> based on the "security=" configuration.
> > 
> > yeah dealing with selection at boot time is going to be needed
> > at some point, whether its now or later ...
> 
> I'll have a go at it then. What that would mean is that:
> 
> 	security=smack,selinux
> 
> gives Smack NetLabel and SELinux xfrm and secmark while
> 
> 	security=selinux,smack
> 
> gives SELinux all three.

That seems reasonable, it also keeps the door open for adding a specific 
network hook ordering option, e.g. "security_net=", at a later date if 
necessary.

> I would still like it to be possible to explicitly configure the allocation
> at build time.

I suppose I have no object to that, I would just place my vote to have the 
dynamic FCFS (or LCFS if that makes more sense) assignment be the Kconfig 
default.

-- 
paul moore
www.paul-moore.com

