Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3ETU5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:57:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3ETU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:57:07 -0400
Date: Mon, 20 May 2013 22:57:03 +0200
From: Jan Kara <jack@suse.cz>
To: Javier Domingo <javierdo1@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Kernel OOPS using auditd Debian 3.2 on a /sys file audit
Message-ID: <20130520205703.GA26992@quack.suse.cz>
References: <CALZVapkH9KN=w_+zVNc2Bgza_HqojA8xt8R+iTeas9x7s5R06Q@mail.gmail.com>
 <CALZVapn-3CLWeScaMcB9kmao_OfSR6_SvRm9_zCgxR7p3sygqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZVapn-3CLWeScaMcB9kmao_OfSR6_SvRm9_zCgxR7p3sygqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-05-13 20:36:59, Javier Domingo wrote:
> I didn't get any reply, is this mailing list still valid, or should I
> ask elsewhere? (this is a ping message)
  This is a high traffic list so your message is likely to just go
unnoticed. It is good to find maintainers of the subsystem (MAINTAINERS
file in kernel sources) and CC them as well - in this case these are
Al Viro <viro@zeniv.linux.org.uk> and Eric Paris <eparis@redhat.com>.

  Also searching in the archives shows that the first message likely didn't
even get it into the list (too large attachment?). Finally, kernel 3.2 is
rather old which reduces the enthusiasm of people here to look into the
problem (although you still might be lucky). So you might have better luck
with reporting this in Debian bug tracking system...

								Honza
> 2013/5/2 Javier Domingo <javierdo1@gmail.com>:
> > Hi,
> >
> > I am currently having problems with the cpu scaling (something is
> > touching the /sys/devices/system/cpu/cpu?/cpufreq/scaling_max_freq),
> > and I decided to use inotify to seek if something was being changed or
> > not.
> >
> > This gave no problems to me, but something is writing just before me,
> > and I can't know from the inotifywait cmd who. Then, I found auditdl,
> > so I put this command onto it:
> >
> > # auditctl -w /sys/devices/system/cpu/cpu?/cpufreq/scaling_max_freq
> >
> > And just after this, this totally blocking OOPS was triggered:
> > [ 5072.685483] BUG: unable to handle kernel NULL pointer dereference
> > at 0000000000000038
> > [ 5072.714302] IP: [<ffffffff8114f06c>] sysfs_dentry_revalidate+0x9/0xa2
> > [ 5072.741249] PGD 12eca4067 PUD 12ec62067 PMD 0
> > [ 5072.768102] Oops: 0000 [#1] SMP
> >
> > I tried to make sysrq, but didn't work. I have repeated several times
> > this and it always crashes. I am attaching the photo of the second
> > time because it is much longer than the second one.
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
