Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaLDR2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:28:50 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61669 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaLDR2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:28:48 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Thu, 4 Dec 2014 12:28:45 -0500
To: Shirley Ma <shirley.ma@oracle.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Tejun Heo <tj@kernel.org>, NeilBrown <neilb@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a
 workqueue-based nfsd
Message-ID: <20141204122845.3f9e3a04@tlielax.poochiereds.net>
In-Reply-To: <5480971D.9010102@oracle.com>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
	<20141203121118.21a32fe1@notabene.brown>
	<20141202202946.1e0f399b@tlielax.poochiereds.net>
	<20141203155649.GB5013@htj.dyndns.org>
	<20141203110405.5ecc85df@tlielax.poochiereds.net>
	<20141203140202.7865bedb@tlielax.poochiereds.net>
	<CAHQdGtQzth78BzBo9Gsz8LKe4ippJv6VYtjGCDmES7viByG_gA@mail.gmail.com>
	<20141203142034.5c14529d@tlielax.poochiereds.net>
	<CAHQdGtSoep_F82tDUoxKar+QvmL1tdHsYgYSrYtktndYJP8g5A@mail.gmail.com>
	<20141203152147.2ca6c6fd@tlielax.poochiereds.net>
	<CAHQdGtSbkvkGnDykEn0RnDJ5infX39N8cQObhDod+Vy4KX3Gnw@mail.gmail.com>
	<20141204064711.72d48317@tlielax.poochiereds.net>
	<5480971D.9010102@oracle.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2014 09:17:17 -0800
Shirley Ma <shirley.ma@oracle.com> wrote:

> I am looking at how to reduce total RPC execution time in NFS/RDMA. mountstats output shows that RPC backlog wait is too long, but increasing the credit limit doesn't seem help. Would this patchset help reducing total RPC execution time? 
> 
> Shirley
> 

I'm not sure. It depends on why you're seeing a backlog.

So far, my testing still shows this to be slightly (~2%) slower than the
same setup running a threaded nfsd, but that could be different with a
NUMA server or faster disks.

Probably there is some more tuning to do here before this is quite
ready for prime-time. It may be worth testing in your environment
though if you have the time and ability to do so.

> On 12/04/2014 03:47 AM, Jeff Layton wrote:
> > I was using ftrace with the sunrpc:* and workqueue:* tracepoints, and
> > had a simple perl script to postprocess the trace info to figure out
> > average/min/max latency.


-- 
Jeff Layton <jlayton@primarydata.com>
