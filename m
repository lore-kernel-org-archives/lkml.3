Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaF3VGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:06:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32972 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaF3VGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:06:18 -0400
Message-ID: <53B1D146.1060606@kernel.dk>
Date: Mon, 30 Jun 2014 15:06:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        pjk1939@linux.vnet.ibm.com
CC: josh.h.morris@us.ibm.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] rsxx: fix discard with length smaller than hw blksize
References: <1404149467-17856-1-git-send-email-cascardo@linux.vnet.ibm.com>
In-Reply-To: <1404149467-17856-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-30 11:31, Thadeu Lima de Souza Cascardo wrote:
> When the discard length is not a multiple of RSXX_HW_BLK_SIZE, the
> discard code will get into an infinite loop, even discarding data it is
> not supposed to. This will also hang the system.
>
> This can be reproduced by doing an ioctl BLKDISCARD to /dev/rsxx0 with
> range from 0 to 1024.

That is a bug that should be fixed in the discard code, not worked 
around in the driver.


-- 
Jens Axboe

