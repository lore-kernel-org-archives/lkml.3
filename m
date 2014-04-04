Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaDDKEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:04:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33918 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaDDKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:04:22 -0400
Message-ID: <533E837A.4040404@mev.co.uk>
Date: Fri, 04 Apr 2014 11:03:38 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: comedi: s626: use comedi_timeout() on remaining
 loops
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com> <1396568607-23447-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1396568607-23447-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-04 00:43, Chase Southwood wrote:
> There were just a handful of more while loops in this file that needed
> timeouts, and this patch takes care of them.  One new callback is
> introduced, and all of the proper comedi_timeout() calls are then used.
> The return type of s626_i2c_handshake() has been changed from uint32_t to
> int so that a negative error code from comedi_timeout() can be propagated
> if necessary.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
> Ian. So, s626_initialize_eoc() has been removed, and its uses swapped
> for s626_i2c_handshake_eoc().
>
> 3: *Type of 'status' variable in s626_i2c_handshake_eoc() has been
> corrected to bool (the return type of s626_mc_test()).
> *Return type of s626_i2c_handshake() has been changed to int to allow
> returning negative error codes.
> *Type of 'ret' variable in the same function has been changed to int for
> the same reason.
>   drivers/staging/comedi/drivers/s626.c | 36 ++++++++++++++++++++++++++---------
>   1 file changed, 27 insertions(+), 9 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
