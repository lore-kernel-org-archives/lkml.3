Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaFWKXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:23:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55109 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaFWKXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:23:22 -0400
Message-ID: <53A80014.7080606@mev.co.uk>
Date: Mon, 23 Jun 2014 11:23:16 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] staging: comedi: addi_apci_1564: fix Change-of-State
 interrupt functionality
References: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-21 23:23, Chase Southwood wrote:
> This patchset introduces a new private data struct for this driver, adds
> all of the code required to support Change-of-State interrupts for the
> digital input subdevice, and finally fixes
> apci1564_interrupt() to service this type of interrupt correctly.
>
> CHANGES FROM v1:
> *leave the send_sig() calls in for now, until the proper replacement can
> be implemented.
> *removed unused static globals, removed the remaining one into the private
> data struct.
> *private data struct moved into addi_apci_1564.c.
> *patches 4/6 and 5/6 from v1 have been merged into patch 4/5 here.
> *(*cancel) for the interrupt subdevice has been reduced to just disable DI
> interrupts rather than using the board's reset function.
> *support for all interrupts issued by the board has been kept in
> apci1564_interrupt(), rather than stripping everything out except for DI
> interrupt support.  However, DI interrupt support has still been fixed.
>
> CHANGES FROM v2:
> *Just refreshed set against staging-next.  Otherwise everything is
> exactly the same, and should apply now.
>
> Chase Southwood (5):
>    staging: comedi: addi_apci_1564: remove use of
>      devpriv->b_OutputMemoryStatus
>    staging: comedi: addi_apci_1564: remove unused static variables
>    staging: comedi: addi_apci_1564: introduce apci1564_private struct
>    staging: comedi: addi_apci_1564: add Change-of-State interrupt
>      subdevice and required functions
>    staging: comedi: addi_apci_1564: move apci1564_interrupt() into
>      addi_apci_1564.c

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
