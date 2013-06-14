Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3FNIDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:03:20 -0400
Received: from lhrrgout.huawei.com ([194.213.3.17]:44193 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FNIDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:03:17 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2013 04:03:16 EDT
Message-ID: <51BACCCC.2000107@huawei.com>
Date: Fri, 14 Jun 2013 09:57:00 +0200
From: Mario Smarduch <mario.smarduch@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Fwd: show_interrupts() after free_irq issue 3.10-rc4?
References: <51BACBCB.1030509@huawei.com>
In-Reply-To: <51BACBCB.1030509@huawei.com>
X-Forwarded-Message-Id: <51BACBCB.1030509@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.220.139.81]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been working with device passthrough & irq
on armv7 after disassociating the device from guest
free_irq() is executed on host. Display of /proc/interrupts
still shows the IRQ info with no irq name associated,
and there is no irq_action associated with the IRQ.
'show_interrupts()' in 'kernel/irq/proc.c' displays
info on the IRQ due to prior stats accumulated.
Few other arch specific ones only on irq_action.

Is there some specific reason for that? To me it
appears misleading to display dormant IRQ info. 
For the end user - use case like above or unloading
driver and seeing the irq show up is confusing as well.
Also not sure what you gain by displaying old IRQ info.

Please cc on responses.

<Sorry for the double copy misspelled mailing list>

- Mario
 



