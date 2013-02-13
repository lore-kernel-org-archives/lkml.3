Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3BMHcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:32:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44306 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3BMHcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:32:17 -0500
Date: Wed, 13 Feb 2013 10:32:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ian Abbott <abbotti@mev.co.uk>, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Fix undefined array subscript
Message-ID: <20130213073214.GR4937@mwanda>
References: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 04:30:54AM +0100, Peter Huewe wrote:
> In vmk80xx_do_insn_bits the local variable reg, which is used as an
> index to the tx_buf array, can be used uninitialized if
> - data[0] == 0
> and
> - devpriv->model != VMK8061_MODEL
> -> we get into the else branch without having reg initialized.

It's weird that GCC doesn't warn about this...

This patch works, or at least it doesn't break anything that wasn't
already broken, but it doesn't feel like the right thing.  Probably
we could move the reg setting outside the if statement.

	if (devpriv->model == VMK8055_MODEL) {
		reg = VMK8055_DO_REG;
		cmd = VMK8055_CMD_WRT_AD;
	} else { /* VMK8061_MODEL */
		reg = VMK8061_DO_REG;
		cmd = VMK8061_CMD_DO;
	}

	if (data[0]) {
		tx_buf[reg] &= ~data[0];

Or maybe data[0] == 0 needs to be handled differently.

Ian would know for sure.

regards,
dan carpenter

