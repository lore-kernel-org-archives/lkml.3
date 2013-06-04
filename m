Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3FDO5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:57:44 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54031 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3FDO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:57:41 -0400
Message-ID: <51AE0053.6010806@gmail.com>
Date: Tue, 04 Jun 2013 22:57:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, devel@driverdev.osuosl.org,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/8] zram: destroy all devices on error recovery
 path in zram_init()
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com> <1370274140-26420-5-git-send-email-jiang.liu@huawei.com> <20130604084916.GM28112@mwanda>
In-Reply-To: <20130604084916.GM28112@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04 Jun 2013 04:49:16 PM CST, Dan Carpenter wrote:
> Everyone stop putting RFC on their bugfixes!  :P  No one wants to
> pre-review patches.
>
> On Mon, Jun 03, 2013 at 11:42:16PM +0800, Jiang Liu wrote:
>> On error recovery path of zram_init(), it leaks the zram device object
>> causing the failure.
>>
>
> This is a real bug but the fix isn't right.  The object causing the
> failure has only been partially set up.  And in some cases it has
> been partially cleaned up, for example we could end up releasing
> ->queue twice.
>
> The better way is to make create_device() clean up after itself
> completely instead of only partly and sometimes.
>
> regards,
> dan carpenter
>
Hi Dan,
     Thanks for your review, will fix it in next version.
Regards!
Gerry

