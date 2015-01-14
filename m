Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbbANN5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:57:38 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62689 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbANN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:57:37 -0500
Date: Wed, 14 Jan 2015 08:57:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
Message-ID: <20150114135733.GB3565@htj.dyndns.org>
References: <54905F87.2030302@jp.fujitsu.com>
 <549061BD.3040802@jp.fujitsu.com>
 <5490DE23.9000602@cn.fujitsu.com>
 <5490F70E.4010703@jp.fujitsu.com>
 <54910CFD.4070203@jp.fujitsu.com>
 <20141225201156.GA22951@htj.dyndns.org>
 <54B4C6ED.9060501@cn.fujitsu.com>
 <20150113152224.GA2976@htj.dyndns.org>
 <54B5D8B4.7010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B5D8B4.7010708@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Jan 14, 2015 at 10:47:16AM +0800, Lai Jiangshan wrote:
> > Even if that involves slightly more code, that's the right thing to do at this point.
> 
> Right, but in currently, the workqueue will be the only user, and I don't known
> asking who to do it, so I may keep it in the workqueue.c.

The problem is that working around this in workqueue effectively hides
what needs to be actively looked upon and decided.  It curently isn't
currently defined even when such mappings can change or for which
cpus?  Are all offline cpus up for grabs or just !present ones?  These
are questions which can only be answered / determined from NUMA side
and the sooner we deal with this properly the better.

> > It'd be
> > awesome if somebody more familiar with the numa side can chime in and
> > explain why this mapping change can't be avoided.
> 
> I'm also looking for someone answer it.

Exactly, whoever is requiring NUMA node remapping should explain and
justify that and how the model to handle it can only be determined
from that.

Thanks.

-- 
tejun
