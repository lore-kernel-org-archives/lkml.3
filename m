Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab3DBB7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:59:42 -0400
Received: from toro.web-alm.net ([62.245.132.31]:42690 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046Ab3DBB7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:59:40 -0400
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 21:59:40 EDT
Message-ID: <515A364B.7070100@osadl.org>
Date: Tue, 02 Apr 2013 03:37:15 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.6.11.1-rt32
References: <1364527527.10629.10.camel@gandalf.local.home>
In-Reply-To: <1364527527.10629.10.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

> I'm pleased to announce the 3.6.11.1-rt32 stable release.
Thank you.

Your patch-3.6.11.1 additionally needs 
23d3b8bfb8eb20e7d96afa09991e6a5ed1c83164 (net: qdisc busylock needs 
lockdep annotations) to avoid the compile error
drivers/net/ppp/ppp_generic.c: In function ‘ppp_dev_init’:
drivers/net/ppp/ppp_generic.c:1027:5: error: ‘struct net_device’ has no 
member named ‘qdisc_tx_busylock’

And since you apparently decided to backport 
303c07db487be59ae9fda10600ea65ca11c21497 (ppp: set qdisc_tx_busylock to 
avoid LOCKDEP splat), you probably should also backport the related 
changes in bonding and team:
- 49ee49202b4ac4be95d05e4bf24a9ac8b54c5528 (bonding: set 
qdisc_tx_busylock to avoid LOCKDEP splat)
- b3c581d5d7130fc7f2eab9ab14c8de8882b42380 (team: set qdisc_tx_busylock 
to avoid LOCKDEP splat)

	-Carsten.
