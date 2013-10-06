Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3JFUzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3JFUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:55:48 -0400
Date: Sun, 6 Oct 2013 13:56:13 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Hans-Frieder Vogt <hfvogt@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] w1 fixes for broken subsystem
Message-ID: <20131006205613.GA5655@kroah.com>
References: <9348473.dVMUCnY2zF@maximilian>
 <65711381092344@web10h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65711381092344@web10h.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:45:44AM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> 06.10.2013, 23:13, "Hans-Frieder Vogt" <hfvogt@gmx.net>:
> > In recent kernels the 1-wire kernel modules do not work any more. The module
> > wire got broken in 3.11-rc1 and 3.12-rc1 introduced a further problem:
> 
> Looks like I somehow missed it and bugs got in
> 
> > 1: 3.11-rc1 introduced the automatic loading of slave modules. This blocks
> > modprobe, because request_module is called with a locked mutex of the w1
> > master.
> > Loading of the slave module calls  w1_register_family, which calls in turn
> > w1_reconnect_slaves and there mutex_lock(&dev->mutex) will wait forever....
> 
> That's correct
> 
> > 2: 3.12-rc1 introduced w1_bus_notify which assumes that all slaves have fops
> > defined. This is not the case for e.g. w1_smem and maybe also breaks custom
> > written modules.
> 
> Isn't fops are supposed to be in the slave device?
> Although they look meaningless for most of devices, I would introduce them everywhere...
> 
> But anyway, your patches fix those problems, thanks a lot.
> Greg, please queue them into appropriate trees.
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Thanks for reviewing this, I'll queue them up in a bit.

greg k-h
