Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3DYTUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:20:14 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:58902 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab3DYTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:20:12 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: John Johansen <john.johansen@canonical.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
Date: Thu, 25 Apr 2013 15:14:20 -0400
Message-ID: <5010864.rEs2oKk1kF@sifl>
User-Agent: KMail/4.10.2 (Linux/3.8.5-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51797153.7050308@schaufler-ca.com>
References: <5176ABB7.5080300@schaufler-ca.com> <47138397.PP25Tg7m1s@sifl> <51797153.7050308@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 25, 2013 11:09:23 AM Casey Schaufler wrote:
> On 4/25/2013 8:01 AM, Paul Moore wrote:
> > On Wednesday, April 24, 2013 05:43:08 PM Casey Schaufler wrote:
> >> On 4/24/2013 4:00 PM, John Johansen wrote:
> >>> On 04/24/2013 02:15 PM, Paul Moore wrote:
> >>>> On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:
> > ...
> > 
> >>>>> An interesting aside that may be relevant is that the error
> >>>>> condition behavior makes it advisable to have the LSM you care
> >>>>> about most go last. If the networking components were strictly
> >>>>> FCFS you might have to chose an ordering you might not want for
> >>>>> other reasons.
> >>>> 
> >>>> Well, maybe not ... I think.  If we take a FCFS approach to the network
> >>>> controls then only one LSM is really ever going to throw an error on
> >>>> the
> >>>> network hooks, yes?
> >> 
> >> You set up the order you want to get the networking handled
> >> correctly and you could get filesystem hooks in the wrong order.
> >> Not that that really ought to be a problem, but there are wonky
> >> admin tools out there.
> > 
> > I don't quite follow; can you be a bit more explicit about getting the
> > filesystem hooks in the wrong order?
> 
> Let's assume that there's a case for the stat() system call that
> would get EPERM from SELinux and EACCES from Smack. A carefully
> crafted admin tool might take different actions based on the return
> code. If Smack ahead of SELinux in the list the tool will respond
> one way, whereas if SELinux is ahead it will behave the other way.
> 
> If this tool came with Fedora it will likely expect the SELinux
> error code. Thus, it will be somewhat important that Smack precede
> SELinux in the LSM ordering. That will grant Smack the NetLabel
> component. If you want SELinux to use NetLabel you'll have to
> explicitly configure that.
> 
> It's probably not going to be an issue that often. Making the
> ordering implications clear to those who may be affected by them
> is probably the best choice and biggest challenge. It would be
> nice to keep them to a minimum. I fear some future LSM author
> getting clever with error codes and demanding the ultimate
> position in all cases.

I guess this begs the question, why does the stacking take the return value 
from the last LSM and not the first?  I'm sure there was a design decision 
made here, I'm just curious about the reasons why.

To me, and maybe I'm the odd one out here, but I would think that the first 
LSM in the stacking order should get precedence; this is why I'm pushing for a 
FCFS for the network controls.  If it turns out that the stacking patches give 
preference for the last LSM in the stacking order (I think this will always 
seem backwards to me) then we should probably give the networking controls to 
the last LSM.

-- 
paul moore
www.paul-moore.com

