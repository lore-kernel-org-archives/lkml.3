Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3FGJcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3FGJch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:32:37 -0400
Message-ID: <51B1A8A5.8050904@redhat.com>
Date: Fri, 07 Jun 2013 11:32:21 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 02/10] zram: use zram->lock to protect zram_free_page()
 in swap free notify path
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com> <1370534851-26056-3-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370534851-26056-3-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:07 PM, Jiang Liu wrote:
> zram_slot_free_notify() is free-running without any protection from
> concurrent operations. So there are race conditions between
> zram_bvec_read()/zram_bvec_write() and zram_slot_free_notify(),
> and possible consequences include:
> 1) Trigger BUG_ON(!handle) on zram_bvec_write() side.
> 2) Access to freed pages on zram_bvec_read() side.
> 3) Break some fields (bad_compress, good_compress, pages_stored)
>    in zram->stats if the swap layer makes concurrently call to
>    zram_slot_free_notify().
> 
> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
> before calling zram_free_page().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Jerome Marchand <jmarchand@redhat.com>


