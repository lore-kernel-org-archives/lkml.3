Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3FDItt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:49:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34486 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FDItq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:49:46 -0400
Date: Tue, 4 Jun 2013 11:49:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, devel@driverdev.osuosl.org,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/8] zram: destroy all devices on error recovery
 path in zram_init()
Message-ID: <20130604084916.GM28112@mwanda>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
 <1370274140-26420-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370274140-26420-5-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone stop putting RFC on their bugfixes!  :P  No one wants to
pre-review patches.

On Mon, Jun 03, 2013 at 11:42:16PM +0800, Jiang Liu wrote:
> On error recovery path of zram_init(), it leaks the zram device object
> causing the failure.
> 

This is a real bug but the fix isn't right.  The object causing the
failure has only been partially set up.  And in some cases it has
been partially cleaned up, for example we could end up releasing
->queue twice.

The better way is to make create_device() clean up after itself
completely instead of only partly and sometimes.

regards,
dan carpenter

