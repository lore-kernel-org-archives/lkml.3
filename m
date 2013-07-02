Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3GBUnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:43:06 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:33242 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3GBUnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:43:03 -0400
Message-ID: <1372797778.1919.17.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v2 net-next] net: convert lls to use time_in_range()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <willemb@google.com>, <erdnetdev@gmail.com>,
        <andi@firstfloor.org>, <hpa@zytor.com>, <devel-lists@codyps.com>,
        <eliezer@tamir.org.il>
Date: Tue, 2 Jul 2013 21:42:58 +0100
In-Reply-To: <51D337D0.1080901@linux.intel.com>
References: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>
	  <20130701.140833.1705666564717621661.davem@davemloft.net>
	  <51D2919F.7050007@linux.intel.com> <51D29329.4060004@linux.intel.com>
	  <51D2A246.3000705@linux.intel.com>
	 <1372795835.1919.14.camel@bwh-desktop.uk.level5networks.com>
	 <51D337D0.1080901@linux.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19988.005
X-TM-AS-Result: No--20.938800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 23:28 +0300, Eliezer Tamir wrote:
> On 02/07/2013 23:10, Ben Hutchings wrote:
> > On Tue, 2013-07-02 at 12:49 +0300, Eliezer Tamir wrote:
> >> Time in range will fail safely if we move to a different cpu with an
> >> extremely large clock skew.
> >> Add time_in_range64() and convert lls to use it.
> >>
> >> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> >> ---
> >> v1->v2
> >> fixed double call to sched_clock() in can_poll_ll(), checkpatchisms
> 
> >> +#define time_in_range64(a, b, c) \
> >> +	(time_after_eq64(a, b) && \
> >> +	 time_before_eq64(a, c))
> > [...]
> >
> > Why not make this an inline function, so the caller doesn't need to
> > worry about repeated evaluation?
> 
> I was following the conventions in jiffies.h
> (well almost, I did add a few spaces to make checkpatch happy)

I see, but now you have a good reason to change that convention.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

