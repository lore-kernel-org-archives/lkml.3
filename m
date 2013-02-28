Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3B1TwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:52:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3B1TwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:52:19 -0500
MIME-Version: 1.0
Message-ID: <175ae3a0-2760-4ec7-869f-46a634ce321d@default>
Date: Thu, 28 Feb 2013 11:50:58 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv6 4/8] zswap: add to mm/
References: <<1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1361397888-14863-5-git-send-email-sjenning@linux.vnet.ibm.com>>
 <42ac68b3-cb1f-48da-bd5e-a368ed62826f@default>
In-Reply-To: <42ac68b3-cb1f-48da-bd5e-a368ed62826f@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Sent: Thursday, February 28, 2013 11:13 AM
> To: Seth Jennings; Andrew Morton
> Cc: Greg Kroah-Hartman; Nitin Gupta; Minchan Kim; Konrad Rzeszutek Wilk; Dan Magenheimer; Robert
> Jennings; Jenifer Hopper; Mel Gorman; Johannes Weiner; Rik van Riel; Larry Woodman; Benjamin
> Herrenschmidt; Dave Hansen; Joe Perches; Joonsoo Kim; Cody P Schafer; linux-mm@kvack.org; linux-
> kernel@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: RE: [PATCHv6 4/8] zswap: add to mm/
> 
> > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > Subject: [PATCHv6 4/8] zswap: add to mm/
> >
> > +/*
> > + * Maximum compression ratio, as as percentage, for an acceptable
> > + * compressed page. Any pages that do not compress by at least
> > + * this ratio will be rejected.
> > +*/
> > +static unsigned int zswap_max_compression_ratio = 80;
> > +module_param_named(max_compression_ratio,
> > +			zswap_max_compression_ratio, uint, 0644);
> 
> Unless this is a complete coincidence, I believe that
> the default value "80" is actually:
> 
> (100 * (1L >> ZS_MAX_ZSPAGE_ORDER)) /
>         ((1L >> ZS_MAX_ZSPAGE_ORDER)) + 1)

Doh! If it wasn't obvious, those should be left
shift operators, not right shift.  So....

(100 * (1L << ZS_MAX_ZSPAGE_ORDER)) /
        ((1L << ZS_MAX_ZSPAGE_ORDER)) + 1)

Sorry for that.
