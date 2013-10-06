Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3JFUwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:52:13 -0400
Received: from forward5h.mail.yandex.net ([84.201.186.23]:57493 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3JFUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:52:12 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Oct 2013 16:52:12 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Hans-Frieder Vogt <hfvogt@gmx.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <9348473.dVMUCnY2zF@maximilian>
References: <9348473.dVMUCnY2zF@maximilian>
Subject: Re: [PATCH 0/2] w1 fixes for broken subsystem
MIME-Version: 1.0
Message-Id: <65711381092344@web10h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 07 Oct 2013 00:45:44 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

06.10.2013, 23:13, "Hans-Frieder Vogt" <hfvogt@gmx.net>:
> In recent kernels the 1-wire kernel modules do not work any more. The module
> wire got broken in 3.11-rc1 and 3.12-rc1 introduced a further problem:

Looks like I somehow missed it and bugs got in

> 1: 3.11-rc1 introduced the automatic loading of slave modules. This blocks
> modprobe, because request_module is called with a locked mutex of the w1
> master.
> Loading of the slave module calls šw1_register_family, which calls in turn
> w1_reconnect_slaves and there mutex_lock(&dev->mutex) will wait forever....

That's correct

> 2: 3.12-rc1 introduced w1_bus_notify which assumes that all slaves have fops
> defined. This is not the case for e.g. w1_smem and maybe also breaks custom
> written modules.

Isn't fops are supposed to be in the slave device?
Although they look meaningless for most of devices, I would introduce them everywhere...

But anyway, your patches fix those problems, thanks a lot.
Greg, please queue them into appropriate trees.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
