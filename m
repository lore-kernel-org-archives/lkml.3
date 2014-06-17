Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbaFQSKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:10:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38006 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaFQSKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:10:46 -0400
Date: Tue, 17 Jun 2014 11:10:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Problems with commit 9ec36cafe4 (of/irq: do irq resolution in
 platform_get_irq) and mfd client devices
Message-ID: <20140617181034.GA25854@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an mfd master and client drivers on a system which has devicetree
enabled. The mfd master driver passes interrupts to the clients using 
mfd cells and 'struct resource'. The client driver is a platform driver
which retrieves the irq using platform_get_irq().

After commit 9ec36cafe (of/irq: do irq resolution in platform_get_irq),
this code no longer works. This is because platform_get_irq() does no
longer call platform_get_resource() if OF is enabled and if dev->of_node
is not NULL (it is not NULL because there is other [static] information
which is passed to the client with devicetree data). 

Any idea how to solve this problem ? How do I now pass a virtual interrupt
from an mfd master to its clients if devicetree is enabled ?

Thanks,
Guenter
