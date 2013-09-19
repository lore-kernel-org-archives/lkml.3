Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3ISLmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:42:09 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:34551 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3ISLmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:42:06 -0400
Date: Thu, 19 Sep 2013 15:42:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: proc hidepid=2 and SGID programs
Message-ID: <20130919114202.GA12144@cachalot>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org>
 <87r4cybio2.fsf@xmission.com>
 <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org>
 <20130914111426.GB4663@cachalot>
 <eb1060ff-d56d-42b7-89f5-a459820edb82@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb1060ff-d56d-42b7-89f5-a459820edb82@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 01:58 -0700, Christian Kujau wrote:
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> >> But still, I wonder if this is 
> >> intended behaviour.
> >
> >Yes.
> >
> >If you think such side channel attacks are something you don't care,
> >just turn hidepid off.  That's why it is an option.
> >
> >If you want to turn it off for some users, use gid=XXX.
> 
> Maybe my initial question got lost in the noise: I merely wondered why "pgrep sgid-program" returned nothing but "kill pics off stiff program" was possible. Sure, if that's intended behavior, so be it. I just don't understand the (technical) reasoning behind this.

If process A may ptrace process B, A may kill B.  In this case A may see
any information about B.

If process A may not ptrace process B, A probably still may kill B.  But
A may not see any information about B.

In sense of information gathering hidepid doesn't differ setgid'ed
processes and common processes of another user.  As *some* privileges
differ between a subject and an object, they are considered as being in
different security domains.  Information leakage crossing the
interdomain border between these domains might help an attacker, so it
is denied.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
