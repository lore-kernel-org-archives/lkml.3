Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3BDTyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:54:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:47973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3BDTyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:54:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="257567289"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Tejun Heo <tj@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: RE: [PATCHSET] idr: implement idr_alloc() and convert existing users
Thread-Topic: [PATCHSET] idr: implement idr_alloc() and convert existing
 users
Thread-Index: AQHOAwydQ2h2OImAJkq/KdAWqmA7TJhqHIQg
Date: Mon, 4 Feb 2013 19:54:12 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D58DF5C@FMSMSX108.amr.corp.intel.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130204191720.GW27963@mtj.dyndns.org>
In-Reply-To: <20130204191720.GW27963@mtj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like this kernel won't compile with CONFIG_HOTPLUG_MEMORY set to 'y'

Mike

> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
> Sent: Monday, February 04, 2013 2:17 PM
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; rusty@rustcorp.com.au; bfields@fieldses.org;
> skinsbursky@parallels.com; ebiederm@xmission.com; jmorris@namei.org;
> axboe@kernel.dk; Marciniszyn, Mike
> Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
> 
> Hello,
> 
> I rolled up all the updates and rebased it on top of today's linux-next
> (20130204).
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git convert-to-idr_alloc
> 
> The git branch contains the following.
> 
>   [1] [PATCH] idr: fix a subtle bug in idr_get_next()
> + [2] [PATCHSET] idr: deprecate idr_remove_all() [3] [PATCHSET] idr:
> + implement idr_alloc() and convert existing users (w/ all updates)
> 
> The only conflict from rebasing it on top of -next is in
> drm_get_connector_status_name() which moved id assignment inside mutex
> and trivial to resolve.
> 
> Given the size of the patchset, I'm waiting a bit more before reposting the
> whole thing.  If anyone wants it reposted now, please let me know.
> 
> Thanks.
> 
> --
> tejun
> 
> [1] https://lkml.org/lkml/2013/2/2/145
> [2] https://lkml.org/lkml/2013/1/25/759
> [3] https://lkml.org/lkml/2013/2/2/159
