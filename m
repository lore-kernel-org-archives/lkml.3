Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3AYV1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab3AYV1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:27:37 -0500
Message-ID: <5102F88F.5010303@redhat.com>
Date: Fri, 25 Jan 2013 16:26:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 1/9] staging: zsmalloc: add gfp flags to zs_create_pool
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1357590280-31535-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 03:24 PM, Seth Jennings wrote:
> zs_create_pool() currently takes a gfp flags argument
> that is used when growing the memory pool.  However
> it is not used in allocating the metadata for the pool
> itself.  That is currently hardcoded to GFP_KERNEL.
>
> zswap calls zs_create_pool() at swapon time which is done
> in atomic context, resulting in a "might sleep" warning.
>
> This patch changes the meaning of the flags argument in
> zs_create_pool() to mean the flags for the metadata allocation,
> and adds a flags argument to zs_malloc that will be used for
> memory pool growth if required.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
