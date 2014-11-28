Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaK1IzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:55:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37579 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaK1IzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:55:16 -0500
Date: Fri, 28 Nov 2014 11:54:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Message-ID: <20141128085436.GF4911@mwanda>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <51dde5250305623c420e78fa555800ef8fef0a09.1417056337.git.micky_ching@realsil.com.cn>
 <20141127152342.GA4860@mwanda>
 <5477D99C.3050903@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5477D99C.3050903@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 02:10:36AM +0000, 敬锐 wrote:
> eg, in sd_ops.c the cmd.arg is constructed bit by bit, we can put the right
> byte to the right register by shift, so the endian check is not need.

I looked at drivers/mmc/core/sd_ops.c and cmd.arg seems to be cpu
endian.

The new function assumes that the cpu is little endian and manually
converts it to little endian.  This is an endian bug.  I think my fix is
correct or something similar.

regards,
dan carpenter
