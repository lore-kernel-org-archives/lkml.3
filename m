Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaBDKc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:32:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30191 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBDKcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:32:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="97667455"
Message-ID: <52F0C1CC.6040706@citrix.com>
Date: Tue, 4 Feb 2014 10:32:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v2 2/4] xen-blkback: fix memory leaks
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com> <1391509575-3949-3-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1391509575-3949-3-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 10:26, Roger Pau Monne wrote:
> I've at least identified two possible memory leaks in blkback, both
> related to the shutdown path of a VBD:
> 
> - blkback doesn't wait for any pending purge work to finish before
>   cleaning the list of free_pages. The purge work will call
>   put_free_pages and thus we might end up with pages being added to
>   the free_pages list after we have emptied it. Fix this by making
>   sure there's no pending purge work before exiting
>   xen_blkif_schedule, and moving the free_page cleanup code to
>   xen_blkif_free.
> - blkback doesn't wait for pending requests to end before cleaning
>   persistent grants and the list of free_pages. Again this can add
>   pages to the free_pages list or persistent grants to the
>   persistent_gnts red-black tree. Fixed by moving the persistent
>   grants and free_pages cleanup code to xen_blkif_free.
> 
> Also, add some checks in xen_blkif_free to make sure we are cleaning
> everything.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

> +	if (log_stats)
> +		print_stats(blkif);

Unrelated to this series, but this log_stats stuff can be removed.

David
