Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3BMOCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:02:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3BMOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:02:22 -0500
Date: Wed, 13 Feb 2013 17:01:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Fix undefined array subscript
Message-ID: <20130213140147.GA4606@mwanda>
References: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de>
 <20130213073214.GR4937@mwanda>
 <511B7F58.4000909@mev.co.uk>
 <511B995E.3030905@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B995E.3030905@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works but it's nasty to re-intialize "reg" inside both
if else statements.  Just do it once at the begining of the
function.

That means we would also delete the ininitialization from the if
side of the if else statement:

 	if (devpriv->model == VMK8061_MODEL) {
-		reg = VMK8061_DO_REG;
 		tx_buf[0] = VMK8061_CMD_RD_DO;

regards,
dan carpenter
