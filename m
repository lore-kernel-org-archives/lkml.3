Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbaKMQtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:49:14 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54470 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaKMQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:49:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined reference to `__aeabi_uldivmod'"
Date: Thu, 13 Nov 2014 17:49:05 +0100
Message-ID: <1799482.v2vqT9blFd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415896047.1787.4.camel@linaro.org>
References: <1415896047.1787.4.camel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ChYDMpe71H00eSgSd3MuUGQ2icr4qe0OtAZFsvMiEmc
 sqNH9zl5nY/Hs8g6ulOuPhpUuDx7tD0hbvHPg+NrGNHqBiBcEV
 q3kxA/hs8M8ZlCQxEySuCc1slvWi2nvmWyXIbrBMwRujpxi9Ey
 35DtGtvP7R6Dsqhy82fUiGY68m5GNdxyDx3XnE1AIKTLKxZoU7
 TFx/sFlRXYSJif1nys78fk8FKlTY2HEgVkPuPHnpvHbRtlqCVz
 kn4Z2b6FWUAEwp4+fFOgK2xr5/BXHy1276UWXGX/b+SuaPq0OP
 LNndA4HqNlhoL3m0miUPX/b1HgO+VA6afIcvQC71WeIazrdKsU
 rjBqYimn6x0fZU34WvBQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 16:27:27 Jon Medhurst wrote:
> 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> implementation of the compiler helper for 64-bit unsigned division,
> therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> the link error "undefined reference to `__aeabi_uldivmod'"
> 
> As the burst value is always a power of two we can fix the problem, and
> make the code more efficient, by replacing "% burst" with "& (burst-1)".
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> 

Just saw the same thing and was going to send a different patch, but
yours is better.

Acked-by: Arnd Bergmann <arnd@arndb.de>
