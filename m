Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab3C0EAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:00:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab3C0EAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:00:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,356,1363104000"; 
   d="scan'208";a="6952372"
Subject: Re: PROBLEM: All CPUs in soft lockup
From: li guang <lig.fnst@cn.fujitsu.com>
To: Robert Norris <robn@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20130327015540.GA27623@pyro.melbourne.osa>
References: <20130327015540.GA27623@pyro.melbourne.osa>
Date: Wed, 27 Mar 2013 11:42:54 +0800
Message-ID: <1364355774.31713.30.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/27 11:44:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/27 11:44:15,
	Serialize complete at 2013/03/27 11:44:15
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems tasks are hogging your cpu/memory resource,
did you check status your servicing processes?

在 2013-03-27三的 12:55 +1100，Robert Norris写道：
> In the last two weeks we've had three servers (identical hardware,
> software and load) hang. The details in this report are from one that
> hung last night.
> 
> They're all IMAP servers servicing many hundreds of users, so several
> thousand processes and active connections. There's been two major
> application level changes in the last couple of weeks, corresponding to
> the time where these hangs started. One is that we now do mail event
> notifications directly to user clients, so more TCP connections. The
> other is that we're now maintaining live search indexes, so a lot more
> disk and tmpfs IO.
> 
> All that said, we're not under what we'd consider to be heavy load. When
> they're running, the servers are fast and responsive.
> 
> During the hang itself, the machine responds to pings, and TCP
> connections can be established, but the servicing processes never
> respond. The console shows a new "BUG: soft lockup" line every few
> seconds, and will not respond to keyboard input. It is a virtual console
> though, which may or may not make a difference, I'm not sure.
> 
> The kernel is 3.4.33 with AUFS patches applied. However there are no
> AUFS mounts on this machine; we use this elsewhere. If you think that's
> a problem I can rebuild for this machine without it.
> 
> Attached are various bits of information requested in REPORTING-BUGS.
> I'm not entirely sure what else is relevant. I'm happy to supply any
> other information and test things, just let me know.
> 
> Thanks,
> Rob.


