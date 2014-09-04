Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaIDIhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:37:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46946 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbaIDIhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:37:45 -0400
Message-ID: <540824D3.8060405@mev.co.uk>
Date: Thu, 4 Sep 2014 09:37:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: hwdrv_apci1500: use dev->class_dev in
 calls to dev_warn()
References: <1409788729-22875-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409788729-22875-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-04 00:58, Chase Southwood wrote:
> git-grep reveals that hwdrv_apci1500.c is the only file in comedi that uses
> dev->hw_dev in calls to dev_{err,warn}().  The rest of the drivers pass
> dev->class_dev to these macros instead.  Switch the dev_warn() calls in
> this driver to use dev->class_dev as well, for consistency.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> As an aside, it looks like lots of these cases are actually error
> conditions that might be more appropriate use cases for dev_err().  But
> they could be changed in a follow on patch, this is enough for this one.
>   .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 104 ++++++++++-----------
>   1 file changed, 52 insertions(+), 52 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
