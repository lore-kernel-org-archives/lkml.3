Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3BRLSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:18:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25167 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3BRLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:18:47 -0500
Date: Mon, 18 Feb 2013 14:18:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, devel@driverdev.osuosl.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/xgifb: Remove duplicated code in loops.
Message-ID: <20130218111824.GE6802@mwanda>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
 <1360957033-11876-5-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360957033-11876-5-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 08:37:13PM +0100, Peter Huewe wrote:
> -	for (i = 0; i < 256; i++) {
> -		outb((unsigned char) DAC_TEST_PARMS[0], (pVBInfo->P3c8 + 1));
> -		outb((unsigned char) DAC_TEST_PARMS[1], (pVBInfo->P3c8 + 1));
> -		outb((unsigned char) DAC_TEST_PARMS[2], (pVBInfo->P3c8 + 1));
> +	for (i = 0; i < 256 * 3; i++) {
> +		outb(0x0F, (pVBInfo->P3c8 + 1)); /* DAC_TEST_PARMS */

The original code looks buggy, but it's been that way from the
initial commit so I have no idea what was intended.  Perhaps the
"+ 1" was supposed to be a "+ i".  There is no way to know really.

regards,
dan carpenter
