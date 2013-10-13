Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3JMPfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:35:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40791 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753186Ab3JMPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:35:01 -0400
Date: Sun, 13 Oct 2013 11:35:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        <tianyu.lan@intel.com>, <broonie@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/hcd: remove unnecessary local_irq_save
In-Reply-To: <1381648459-2957-1-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1310131133410.11381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Oct 2013, Michael Opdenacker wrote:

> Remove the use of local_irq_save() and IRQF_DISABLED, no longer needed since
> interrupt handlers are always run with interrupts disabled on the
> current CPU.
> 
> Tested successfully with 3.12.0-rc4 on my PC. Didn't find
> any issue because of this change.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/usb/core/hcd.c | 15 ---------------
>  1 file changed, 15 deletions(-)

How about removing all the other unnecessary usages of IRQF_DISABLED
under drivers/usb while you're at it?

Alan Stern

