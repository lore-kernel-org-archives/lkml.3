Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3BGQPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:15:35 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60692 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab3BGQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:15:34 -0500
Message-ID: <5113D291.2020903@linux.vnet.ibm.com>
Date: Thu, 07 Feb 2013 10:13:05 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
CC: Rik van Riel <riel@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com> <51030ADA.8030403@redhat.com> <510698F5.5060205@linux.vnet.ibm.com> <5107A2B8.4070505@parallels.com>
In-Reply-To: <5107A2B8.4070505@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020716-5518-0000-0000-00000B5FB5EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 04:21 AM, Lord Glauber Costa of Sealand wrote:
> On 01/28/2013 07:27 PM, Seth Jennings wrote:
>> Yes, I prototyped a shrinker interface for zswap, but, as we both
>> figured, it shrinks the zswap compressed pool too aggressively to the
>> point of being useless.
> Can't you advertise a smaller number of objects that you actively have?

Thanks for looking at the code!

An interesting idea.  I'm just not sure how you would manage the
underlying policy of how aggressively does zswap allow itself to be
shrunk?  The fact that zswap _only_ operates under memory pressure
makes that policy difficult, because it is under continuous shrinking
pressure, unlike other shrinkable caches in the kernel that spend most
of their time operating in unconstrained or lightly/intermittently
strained conditions.

Thanks,
Seth

