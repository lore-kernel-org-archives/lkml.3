Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3JFTN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:13:26 -0400
Received: from mout.gmx.net ([212.227.15.19]:55629 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3JFTNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:13:25 -0400
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: gregkh@linuxfoundation.org, zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] w1 fixes for broken subsystem
Date: Sun, 06 Oct 2013 21:13:13 +0200
Message-ID: <9348473.dVMUCnY2zF@maximilian>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc2-a64; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:SbTo0eopMlwYgIOYmVxhFDptqyIh0YPAt1ge28B0RQJsi6adROZ
 kBBOja0jLSD7BKg+UqHW+J1lUZ3csnojBSc2vUpgjTG392manjUU8I4A/Fbpce7NBonn9C0
 9gigJzEi1gH2xQcIqDdN39LcymzZhOXXfeMgwQ+dc4sChmvkigevbWHLZ6+QOGDZfni7gj8
 IsjHmsHn01I+BgH7jjyGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In recent kernels the 1-wire kernel modules do not work any more. The module 
wire got broken in 3.11-rc1 and 3.12-rc1 introduced a further problem:

1: 3.11-rc1 introduced the automatic loading of slave modules. This blocks 
modprobe, because request_module is called with a locked mutex of the w1 
master.
Loading of the slave module calls  w1_register_family, which calls in turn
w1_reconnect_slaves and there mutex_lock(&dev->mutex) will wait forever....

2: 3.12-rc1 introduced w1_bus_notify which assumes that all slaves have fops 
defined. This is not the case for e.g. w1_smem and maybe also breaks custom 
written modules.

This very small patch set is split in 2 parts:

PATCH 1/2: w1 - fix fops in w1_bus_notify
fixes problem 2 above

PATCH 2/2: w1 - call request_module with w1 master mutex unlocked
fixes problem 1 above

Please include these patches in 3.12-rc4 and in 3.11 stable.

Best regards,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
