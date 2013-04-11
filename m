Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab3DKRut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:50:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab3DKRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:50:47 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=bZztnH6OdnNspq2TyXQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365702645.9609.41.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.11.1-rt32
From: Steven Rostedt <rostedt@goodmis.org>
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Date: Thu, 11 Apr 2013 13:50:45 -0400
In-Reply-To: <515A364B.7070100@osadl.org>
References: <1364527527.10629.10.camel@gandalf.local.home>
	 <515A364B.7070100@osadl.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 03:37 +0200, Carsten Emde wrote:
> Steven,
> 
> > I'm pleased to announce the 3.6.11.1-rt32 stable release.
> Thank you.
> 
> Your patch-3.6.11.1 additionally needs 
> 23d3b8bfb8eb20e7d96afa09991e6a5ed1c83164 (net: qdisc busylock needs 
> lockdep annotations) to avoid the compile error
> drivers/net/ppp/ppp_generic.c: In function ‘ppp_dev_init’:
> drivers/net/ppp/ppp_generic.c:1027:5: error: ‘struct net_device’ has no 
> member named ‘qdisc_tx_busylock’

Hmm, I was able to do a full 3.6.11.1 allmodconfig without this (see
below). But I'll add it anyway.

> 
> And since you apparently decided to backport 
> 303c07db487be59ae9fda10600ea65ca11c21497 (ppp: set qdisc_tx_busylock to 
> avoid LOCKDEP splat), you probably should also backport the related 

Oh, I added this by mistake, and I believe this is what caused the above
compile problem. I reverted this as the first patch for .2, and I
compiled 3.6.11.1 with this revert on an allmodconfig.

-- Steve


> changes in bonding and team:
> - 49ee49202b4ac4be95d05e4bf24a9ac8b54c5528 (bonding: set 
> qdisc_tx_busylock to avoid LOCKDEP splat)
> - b3c581d5d7130fc7f2eab9ab14c8de8882b42380 (team: set qdisc_tx_busylock 
> to avoid LOCKDEP splat)
> 
> 	-Carsten.


