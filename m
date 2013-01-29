Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3A2KVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:21:36 -0500
Received: from mx2.parallels.com ([64.131.90.16]:46719 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3A2KVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:21:31 -0500
Message-ID: <5107A2B8.4070505@parallels.com>
Date: Tue, 29 Jan 2013 14:21:44 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        "Johannes Weiner" <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com> <51030ADA.8030403@redhat.com> <510698F5.5060205@linux.vnet.ibm.com>
In-Reply-To: <510698F5.5060205@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 07:27 PM, Seth Jennings wrote:
> Yes, I prototyped a shrinker interface for zswap, but, as we both
> figured, it shrinks the zswap compressed pool too aggressively to the
> point of being useless.
Can't you advertise a smaller number of objects that you actively have?

Since the shrinker would never try to shrink more objects than you
advertised, you could control pressure this way.

