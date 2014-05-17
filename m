Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaEQOoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:44:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28385 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaEQOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:44:52 -0400
Date: Sat, 17 May 2014 17:44:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Jes.Sorensen@redhat.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/2] staging: rtl8188eu: fix usage of uninit scalar in
 rtw_drv_init()
Message-ID: <20140517144423.GA15585@mwanda>
References: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
 <1400323138-32243-2-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400323138-32243-2-git-send-email-cengelma@gmx.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 12:38:57PM +0200, Christian Engelmayer wrote:
> Function rtw_drv_init() is written in a way that assumes 'status' != _SUCCESS
> as long as not explicitly set. Thus initialize 'status' to FAIL, in order to
> prevent undefined behaviour if going through the exit paths. Detected by
> Coverity - CID 1077832.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

This is a bugfix and we like to merge bugfixes without asking redo
things, so don't redo.  But really the better fix is to get rid of the
status variable completely.  Just return directly on the success path.

If we were to do that, then both patches would be merged together and
called:  [patch] Staging: rtl8188eu: fix error handling in rtw_drv_init()

But this patch is also acceptable as-is.  Thanks for fixing the bug.  :)

regards,
dan carpenter

