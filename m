Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3G2Pf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:35:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36071 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3G2PfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:35:24 -0400
Date: Mon, 29 Jul 2013 08:35:19 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: A call to revise sockets behaviour
Message-ID: <20130729083519.5d574f16@nehalam.linuxnetplumber.net>
In-Reply-To: <2066879158.39771.1375110634453.JavaMail.mail@webmail09>
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 15:10:34 +0000 (UTC)
"Artem S. Tashkinov" <t.artem@lycos.com> wrote:

> Hello,
> 
> Currently the Linux kernel disallows to start listening on a TCP/UDP socket if
> there are open connections against the port, regardless connections status. So even
> if _all_ you have is some stale (i.e. no longer active connections pending destruction)
> the kernel will not allow to reuse this socket.
> 
> Stephen Hemminger argues that this behaviour is expected even though it's 100%
> counter productive, it defies common sense and I cannot think of any security implications
> should this feature be allowed.
> 
> Besides, when discussing this bug on Wine's bugzilla I have shown that this behavior not
> only affect Windows applications running under Wine, but also native POSIX applications.
> 
> If nothing else is listening to incoming connections how can _old_ _stale_ connections
> prevent an application from listening on the port? Windows has no qualms about allowing
> that, why the Linux kernel works differently?
> 
> I want to hear how the current apparently _broken_ behaviour, "The current socket API
> behavior is unlikely to be changed because so many applications expect it", can be expected.
> 
> Also I'd like to know which applications depend on this "feature".
> 
> Imagine a situation,
> 
> You have an apache server serving connections on port 80. For some reasons a crash in
> one of its modules causes the daemon crash but during the crash Apache had some open
> connections on this port.
> 
> According to Stephen Hemminger I cannot relaunch Apache until the kernel waits arbitrary
> time in order to clean stale connections for its networking pool.
> 
> I fail to see how this behaviour can be "expected".
> 
> More on it here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=45571
> http://bugs.winehq.org/show_bug.cgi?id=26031

I understand your problem, people have been having to deal with it for 30 years.
The attitude in your response makes it seem like you just discovered fire,
read a book like Steven's network programming if you need more info.

If you don't use SO_REUSEADDR then yes application has to wait for time wait
period.

If you do enable SO_REUSEADDR then it is possible to bind to a port with existing
stale connections.


