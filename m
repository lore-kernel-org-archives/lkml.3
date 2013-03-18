Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3CRTQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:16:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29024 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3CRTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:16:37 -0400
Date: Mon, 18 Mar 2013 22:16:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: omap-thermal: use spin_lock_irqsave inside
 IRQ handler
Message-ID: <20130318191618.GU9138@mwanda>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
 <1363618756-15851-3-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363618756-15851-3-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:59:10AM -0400, Eduardo Valentin wrote:
> Even if the IRQ is not firing because it is ONE_SHOT and disable
> at INTC level, the IRQ handler must use spin_lock_irqsave.
> It is necessary to disable IRQs from the current
> CPU while it is holding a spin_lock which is need.
> 

Gar...  I think I was just totally wrong on this.  I think your
original code was fine.  Sorry Eduardo and Greg.

This is a threaded IRQ so the regular spin_lock is fine or even the
mutex would have been.

IRQ_ONESHOT is about triggering a second IRQ before the first one
has been finished, btw.

I am an idiot.

regards,
dan carpenter

