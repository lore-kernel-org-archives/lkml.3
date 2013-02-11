Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3BKE0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:26:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8481 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3BKE0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:26:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 10 Feb 2013 20:22:35 -0800
Message-ID: <51187376.2060106@nvidia.com>
Date: Mon, 11 Feb 2013 13:28:38 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] gpiolib: Fix locking on gpio debugfs files
References: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 07:34 PM, Grant Likely wrote:
> The debugfs files really need to hold the gpiolib spinlock before
> accessing the list. Otherwise chip addition/removal will cause an oops.
>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Tested-by: Alexandre Courbot <acourbot@nvidia.com>

Just wondering: if we manage to change this spinlock into a mutex in the 
future, wouldn't it be better to acquire it only once in 
gpiolib_seq_start() and release it in gpiolib_seq_stop()?

Even though the protection introduced by this patch definitely improves 
the situation, it seems to me that chips could still be removed while 
being displayed by gpiolib_seq_show().

Thanks,
Alex.
