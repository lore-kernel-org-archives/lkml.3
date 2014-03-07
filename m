Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaCGRQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:16:52 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55358 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbaCGRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:16:51 -0500
Message-ID: <1394212609.1987.6.camel@x41>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Fri, 07 Mar 2014 18:16:49 +0100
In-Reply-To: <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
	 <1394185698.5608.5.camel@x41>
	 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2014 17:16:50.0483 (UTC) FILETIME=[0722E030:01CF3A29]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas schreef op vr 07-03-2014 om 09:55 [-0700]:
> On Fri, Mar 7, 2014 at 2:48 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > This might end up not being relevant. And this is surely documented
> > somewhere, but anyhow:
> > - what git magic returns the hashes of the 15 commits that merge commit
> >   96702be56037 added to the tree; and
> 
> "git show 96702be56037" gives:
> 
>     commit 96702be560374ee7e7139a34cab03554129abbb4
>     Merge: 04f982beb900 d56dbf5bab8c
>     ...
> 
> 04f982beb900 is the previous HEAD, d56dbf5bab8c is the head of the
> branch merged by this commit.  "git log 04f982beb900..96702be56037"
> shows the commits merged.

Thanks. Fairly obvious, actually. Not sure why I didn't think of this
myself.

> > - how can I use the list of those hashes to limit the range of commits
> >   to do a git bisect?
> 
> I'm not a git bisect expert, but I *think* you should be able to do
> something like this:
> 
>     git bisect start
>     git bisect bad 96702be56037
>     git bisect good 04f982beb900
> 
> (assuming you've verified that 96702be56037 really *is* bad and
> 04f982beb900 really *is* good), and git should checkout something in
> the middle and you can build and test it, then use "git bisect good"
> or "git bisect bad" depending on the result.

Makes sense. Thanks again. 04f982beb900 appears to be good. So if
96702be56037 turns out to be bad bisecting might not turn into the
ordeal it usually is. (On this machine, with my workflow, bisecting an
v3.x..v3.x+1-rcy range takes a few days.)


Paul Bolle

