Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJTTTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:19:32 -0400
Received: from www17.your-server.de ([213.133.104.17]:55741 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJTTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:19:30 -0400
Message-ID: <1413832768.2991.39.camel@localhost.localdomain>
Subject: Re: [uml-devel] [UM] Long loop in __getnsdayoftime() after resume
 from ram
From: Thomas Meyer <thomas@m3y3r.de>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Date: Mon, 20 Oct 2014 21:19:28 +0200
In-Reply-To: <5444DC3F.20601@nod.at>
References: <E1Xg9cr-0007LK-S6@www17.your-server.de> <5444DC3F.20601@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 20.10.2014, 11:56 +0200 schrieb Richard Weinberger:
> Am 20.10.2014 um 11:51 schrieb Thomas Meyer:
> >> Hmm, does this always happen?
> > 
> > Yes, my single core system seems to trigger this every time after resume from ram.
> 
> What is your host kernel?

The standard Fedora kernel: 3.16.4-200.fc20.x86_64

> 
> >> At least on my notebook it did not happen. I've started an UML yesterday 
> >> suspended it and after more than 12h it worked fine today. 
> >>
> >> BTW: Do you see the issue also then freezing UML using the freezer cgroup?
> > 
> > I'm not sure what do you mean by this. Do I need to enable some special configs for this in the host or uml kernel?
> 
> Create on the host side a new freezer cgroup, put UML into it and freeze/thaw it.
> i.e. mkdir /sys/fs/cgroup/freezer/uml ; echo <pid of a shell> >  /sys/fs/cgroup/freezer/uml/tasks.
> In the said shell run UML and then freeze it using echo FROZEN > /sys/fs/cgroup/freezer/uml/freezer.state.
> Later thaw it: echo THAWED > /sys/fs/cgroup/freezer/uml/freezer.state
> 

I'll try this.
Thanks for this tip.

with kind regards
thomas


