Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaLDRRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:17:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44445 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaLDRRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:17:34 -0500
Message-ID: <5480971D.9010102@oracle.com>
Date: Thu, 04 Dec 2014 09:17:17 -0800
From: Shirley Ma <shirley.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
CC: Tejun Heo <tj@kernel.org>, NeilBrown <neilb@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a workqueue-based
 nfsd
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>	<20141203121118.21a32fe1@notabene.brown>	<20141202202946.1e0f399b@tlielax.poochiereds.net>	<20141203155649.GB5013@htj.dyndns.org>	<20141203110405.5ecc85df@tlielax.poochiereds.net>	<20141203140202.7865bedb@tlielax.poochiereds.net>	<CAHQdGtQzth78BzBo9Gsz8LKe4ippJv6VYtjGCDmES7viByG_gA@mail.gmail.com>	<20141203142034.5c14529d@tlielax.poochiereds.net>	<CAHQdGtSoep_F82tDUoxKar+QvmL1tdHsYgYSrYtktndYJP8g5A@mail.gmail.com>	<20141203152147.2ca6c6fd@tlielax.poochiereds.net>	<CAHQdGtSbkvkGnDykEn0RnDJ5infX39N8cQObhDod+Vy4KX3Gnw@mail.gmail.com> <20141204064711.72d48317@tlielax.poochiereds.net>
In-Reply-To: <20141204064711.72d48317@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking at how to reduce total RPC execution time in NFS/RDMA. mountstats output shows that RPC backlog wait is too long, but increasing the credit limit doesn't seem help. Would this patchset help reducing total RPC execution time? 

Shirley

On 12/04/2014 03:47 AM, Jeff Layton wrote:
> I was using ftrace with the sunrpc:* and workqueue:* tracepoints, and
> had a simple perl script to postprocess the trace info to figure out
> average/min/max latency.
