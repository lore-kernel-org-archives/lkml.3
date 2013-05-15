Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3EOU4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:56:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab3EOU4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:56:37 -0400
MIME-Version: 1.0
Message-ID: <25f0f975-d9aa-4e00-bc34-acfd9b86b6bd@default>
Date: Wed, 15 May 2013 13:55:44 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@sr71.net>, Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joe Perches <joe@perches.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: RE: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default>
 <20130514163541.GC4024@medulla>
 <f0272a06-141a-4d33-9976-ee99467f3aa2@default>
 <20130514225501.GA11956@cerebellum>
 <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default>
 <20130515185506.GA23342@phenom.dumpdata.com>
 <20130515200942.GA17724@cerebellum> <5193EEE7.80603@sr71.net>
In-Reply-To: <5193EEE7.80603@sr71.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@sr71.net]
> Sent: Wednesday, May 15, 2013 2:24 PM
> To: Seth Jennings
> Cc: Konrad Rzeszutek Wilk; Dan Magenheimer; Andrew Morton; Greg Kroah-Hartman; Nitin Gupta; Minchan
> Kim; Robert Jennings; Jenifer Hopper; Mel Gorman; Johannes Weiner; Rik van Riel; Larry Woodman;
> Benjamin Herrenschmidt; Joe Perches; Joonsoo Kim; Cody P Schafer; Hugh Dickens; Paul Mackerras; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On 05/15/2013 01:09 PM, Seth Jennings wrote:
> > On Wed, May 15, 2013 at 02:55:06PM -0400, Konrad Rzeszutek Wilk wrote:
> >>> Sorry, but I don't think that's appropriate for a patch in the MM subsystem.
> >>
> >> Perhaps a compromise can be reached where this code is merged as a driver
> >> not a core mm component. There is a high bar to be in the MM - it has to
> >> work with many many different configurations.
> >>
> >> And drivers don't have such a high bar. They just need to work on a specific
> >> issue and that is it. If zswap ended up in say, drivers/mm that would make
> >> it more palpable I think.
> 
> The issue is not whether it is a loadable module or a driver.  Nobody
> here is stupid enough to say, "hey, now it's a driver/module, all of the
> complex VM interactions are finally fixed!"
> 
> If folks don't want this in their system, there's a way to turn it off,
> today, with the sysfs tunables.  We don't need _another_ way to turn it
> off at runtime (unloading the module/driver).

The issue is we KNOW the complex VM interactions are NOT fixed
and there has been very very little breadth testing (i.e.
across a wide range of workloads, and any attempts to show
how much harm can come from enabling it.)

That's (at least borderline) acceptable in a driver that can
be unloaded, but not in MM code IMHO.
