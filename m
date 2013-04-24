Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3DXF4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 01:56:11 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60977 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3DXF4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 01:56:10 -0400
X-Auth-Info: xpeDRIVcWaprytlgZ/qyXPtH0DW7UfB/kf3in/b45/I=
Date: Wed, 24 Apr 2013 07:55:54 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Tiejun Chen <tiejun.chen@windriver.com>
Cc: <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: ehci-fsl: set INCR8 mode only on MPC512x
Message-ID: <20130424075554.1ae85c65@crub>
In-Reply-To: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com>
References: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 10:55:10 +0800
Tiejun Chen <tiejun.chen@windriver.com> wrote:

> commit 761bbcb7, "usb: ehci-fsl: set INCR8 mode for system bus interface
> on MPC512x", introduced to fix one MPC5121e (M36P) Errata by setting
> INCR8 mode for system bus interface on MPC512x, but we should make sure
> this is only valid for MPC512x like other parts of this commit. Otherwise

NAK. It is already only valid for MPC512x.

> this would issue other platforms as abnormal without this similar Errata.

This setting is in the ehci_fsl_mpc512x_drv_resume() function which is
not called on other platforms.

Thanks,

Anatolij
