Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3KRTa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:30:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3KRTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:30:56 -0500
Message-ID: <528A6AD4.7080702@kernel.dk>
Date: Mon, 18 Nov 2013 12:30:28 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] bio: fix argument of __bio_add_page() for max_sectors
 > 0xffff
References: <1384780302-25009-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1384780302-25009-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 06:11 AM, Akinobu Mita wrote:
> The data type of max_sectors and max_hw_sectors in queue settings are
> unsigned int.  But these values are passed to __bio_add_page() as an
> argument whose data type is unsigned short.  In the worst case such as
> max_sectors is 0x10000, bio_add_page() can't add a page and IOs can't
> proceed.

Thanks, added. Even at 512b sectors, 0xffff sectors would be a huuuuge
page. So I don't think we'd ever see this bug hit, iirc huge pages are
still broken down for IO. But it's better to be safe...
-- 
Jens Axboe

