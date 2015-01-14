Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbANRBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:01:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34055 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbANRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:01:06 -0500
Date: Wed, 14 Jan 2015 17:00:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "jcm@redhat.com" <jcm@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs topology for arm64 cluster_id
Message-ID: <20150114170045.GC21115@leverpostej>
References: <54B5BC84.8090603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B5BC84.8090603@redhat.com>
Thread-Topic: sysfs topology for arm64 cluster_id
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:47:00AM +0000, Jon Masters wrote:
> Hi Folks,
> 
> TLDR: I would like to consider the value of adding something like
> "cluster_siblings" or similar in sysfs to describe ARM topology.
> 
> A quick question on intended data representation in /sysfs topology
> before I ask the team on this end to go down the (wrong?) path. On ARM
> systems today, we have a hierarchical CPU topology:
> 
>                  Socket ---- Coherent Interonnect ---- Socket
>                    |                                    |
>          Cluster0 ... ClusterN                Cluster0 ... ClusterN
>             |             |                      |             |
>       Core0...CoreN  Core0...CoreN        Core0...CoreN  Core0...CoreN
>         |       |      |        |           |       |      |       |
>      T0..TN  T0..Tn  T0..TN  T0..TN       T0..TN T0..TN  T0..TN  T0..TN
> 
> Where we might (or might not) have threads in individual cores (a la SMT
> - it's allowed in the architecture at any rate) and we group cores
> together into units of clusters usually 2-4 cores in size (though this
> varies between implementations, some of which have different but similar
> concepts, such as AppliedMicro Potenza PMDs CPU complexes of dual
> cores). There are multiple clusters per "socket", and there might be an
> arbitrary number of sockets. We'll start to enable NUMA soon.

I have a slight disagreement with the diagram above.

The MPIDR_EL1.Aff* fields and the cpu-map bindings currently only
describe the hierarchy, without any information on the relative
weighting between levels, and without any mapping to HW concepts such as
sockets. What these happen to map to is specific to a particular system,
and the hierarchy may be carved up in a number of possible ways
(including "virtual" clusters). There are also 24 RES0 bits that could
potentially become additional Aff fields we may need to describe in
future.

"socket", "package", etc are meaningless unless the system provides a
mapping of Aff levels to these. We can't guess how the HW is actually
organised.

Mark.
