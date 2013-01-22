Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3AVX7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:59:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24137 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3AVX7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:59:23 -0500
MIME-Version: 1.0
Message-ID: <6dc259d4-440e-4926-bf5f-e9deb9a19f09@default>
Date: Tue, 22 Jan 2013 15:58:53 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: High slab usage testing with zcache/zswap (Was: [PATCH 7/8] zswap:
 add to mm/)
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>
 <0e91c1e5-7a62-4b89-9473-09fff384a334@default>
 <50E32255.60901@linux.vnet.ibm.com> <50E4588E.6080001@linux.vnet.ibm.com>
 <28a63847-7659-44c4-9c33-87f5d50b2ea0@default>
 <50E479AD.9030502@linux.vnet.ibm.com>
 <9955b9e0-731b-4cbf-9db0-683fcd32f944@default>
 <20130103073339.GF3120@dastard>
In-Reply-To: <20130103073339.GF3120@dastard>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Thursday, January 03, 2013 12:34 AM
> Subject: Re: [PATCH 7/8] zswap: add to mm/
> 
> > > On 01/02/2013 09:26 AM, Dan Magenheimer wrote:
> > > > However if one compares the total percentage
> > > > of RAM used for zpages by zswap vs the total percentage of RAM
> > > > used by slab, I suspect that the zswap number will dominate,
> > > > perhaps because zswap is storing primarily data and slab is
> > > > storing primarily metadata?
> > >
> > > That's *obviously* 100% dependent on how you configure zswap.  But, that
> > > said, most of _my_ systems tend to sit with about 5% of memory in
> > > reclaimable slab
> >
> > The 5% "sitting" number for slab is somewhat interesting, but
> > IMHO irrelevant here. The really interesting value is what percent
> > is used by slab when the system is under high memory pressure; I'd
> > imagine that number would be much smaller.  True?
> 
> Not at all. The amount of slab memory used is wholly dependent on
> workload. I have plenty of workloads with severe memory pressure
> that I test with that sit at a steady state of >80% of ram in slab
> caches. These workloads are filesytem metadata intensive rather than
> data intensive, that's exactly the right cache balance for the
> system to have....

Hey Dave --

I'd like to do some zcache policy testing where the severe
memory pressure is a result of something like the above
where >80% of ram is in slab caches.  Any thoughts on how
to do this or easily simulate it on a very simple hardware
system (e.g. PC with one SATA disk)?  Or is a "big data"
configuration required?

Thanks for any advice!
Dan
