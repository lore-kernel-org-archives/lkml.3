Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3FHBJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:09:47 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53458 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3FHBJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:09:45 -0400
Date: Fri, 7 Jun 2013 18:09:48 -0700
From: Olof Johansson <olof@lixom.net>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH v2 1/3] ARM: EXYNOS: uncompress - print debug messages if
 DEBUG_LL is defined
Message-ID: <20130608010948.GA27436@quad.lixom.net>
References: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org>
 <1370319552-17694-2-git-send-email-tushar.behera@linaro.org>
 <51B05135.3020006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B05135.3020006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 02:37:01PM +0530, Tushar Behera wrote:
> On 06/04/2013 09:49 AM, Tushar Behera wrote:
> > Printing low-level debug messages make an assumption that the specified
> > UART port has been preconfigured by the bootloader. Incorrectly
> > specified UART port results in system getting stalled while printing the
> > message "Uncompressing Linux... done, booting the kernel"
> > This UART port number is specified through S3C_LOWLEVEL_UART_PORT. Since
> > the UART port might different for different board, it is not possible to
> > specify it correctly for every board that use a common defconfig file.
> > 
> > Calling this print subroutine only when DEBUG_LL fixes the problem. By
> > disabling DEBUG_LL in default config file, we would be able to boot
> > multiple boards with different default UART ports.
> > 
> > With this current approach, we miss the print "Uncompressing Linux...
> > done, booting the kernel." when DEBUG_LL is not defined.
> > 
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > ---
> > Change for v2:
> > * Instead of checking value of uart_base, now check if DEBUG_LL
> > is enabled. This removes the ifdef's from mach/uncompress.h
> > 
> > 
> >  arch/arm/plat-samsung/include/plat/uncompress.h |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> 
> If there are no concerns, would it be possible to queue this patch [1/3]
> for 3.10?
> 
> The other two patches can wait for 3.11.

Sure, I've applied it to fixes for 3.10.


-Olof
