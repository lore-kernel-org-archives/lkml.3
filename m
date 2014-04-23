Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaDWKrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:47:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:45291 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaDWKrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:47:49 -0400
Message-ID: <53579A4F.6010108@mev.co.uk>
Date: Wed, 23 Apr 2014 11:47:43 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v4] staging: comedi: addi_apci_1564: tidy up apci1564_reset()
References: <1397716383-699-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397716383-699-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-17 07:33, Chase Southwood wrote:
> The reset function for this driver is a bit of a mess; clean it up to
> ensure that it is functioning properly.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: *Changed order of register accesses for digital input registers back to
> original ordering.
> *Removed read of digital output status register and reordered the accesses
> of digital output registers to agree with the order found in addi_apci_2032.
> *Fixed copy/paste error in the counter register reset lines.
>
> 3: *Returned the reset callback to the boardinfo...oops.
> *Don't write APCI1564_DO_IRQ_REG (it's read only).
> *Don't clear counter reload values...counters have already been
> disabled.
>
> 4: Leave this in hwdrv_apci1564.c for now (it can be moved after separating
> this driver from addi_common.c)
>
> NB: This patch has been renamed in this version.  It was previously known
> as "staging: comedi: addi_apci_1564: fixup and absorb apci1564_reset()"
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 24 ++++++++++++++--------
>   1 file changed, 15 insertions(+), 9 deletions(-)

Looks okay and it addresses the concerns raised by Hartley.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
