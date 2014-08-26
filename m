Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbaHZORz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:17:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115AbaHZORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:17:53 -0400
Message-ID: <53FC970E.9030607@kernel.dk>
Date: Tue, 26 Aug 2014 08:17:50 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sabrina Dubroca <sd@queasysnail.net>, hch@lst.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix error handling in sg_io
References: <20140826135143.GA30461@lst.de> <1409062442-32766-1-git-send-email-sd@queasysnail.net>
In-Reply-To: <1409062442-32766-1-git-send-email-sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 08:14 AM, Sabrina Dubroca wrote:
> Before commit 2cada584b200 ("block: cleanup error handling in sg_io"),
> we had ret = 0 before entering the last big if block of sg_io.
> 
> Since 2cada584b200, ret = -EFAULT, which breaks hdparm:
> 
> /dev/sda:
>  setting Advanced Power Management level to 0xc8 (200)
>  HDIO_DRIVE_CMD failed: Bad address
>  APM_level      = 128
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Fixes: 2cada584b200 ("block: cleanup error handling in sg_io")

Thanks, good catch. Someone else reported a regression with identical
symptoms to me yesterday, but did not follow up, so I'm glad you both
found and fixed it.


-- 
Jens Axboe

