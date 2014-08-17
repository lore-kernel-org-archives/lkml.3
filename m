Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaHQKUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:20:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52267 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaHQKUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:20:19 -0400
Message-ID: <53F081E2.5060207@mev.co.uk>
Date: Sun, 17 Aug 2014 11:20:18 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging: comedi: dt3000: remove unneeded variable
References: <1408249571-1478-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1408249571-1478-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/14 05:26, Chase Southwood wrote:
> Coccinelle (using scripts/coccinelle/tests/doublebitand.cocci) found this
> assignment because 0 is or'd twice.  Upon inspection, I found that the
> variable "mode" is only assigned once and used once, and thus can be
> cleanly removed.  This patch plugs its value straight into writew() and
> then removes the variable.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> It occurred to me while doing this that zero might be or'd twice to
> indicate "no information" in order to maintain some three-part structure
> used elsewhere.  If this is the case, I think that the variable could
> still be removed and the "| 0 | 0" could be added to the writew().
>
>   drivers/staging/comedi/drivers/dt3000.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)

This shouldn't be in the same series as the other two patches, but never 
mind.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
