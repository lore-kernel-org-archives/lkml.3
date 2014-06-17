Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbaFQUIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:08:47 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:36090 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140617181034.GA25854@roeck-us.net>
References: <20140617181034.GA25854@roeck-us.net>
From: Rob Herring <robh@kernel.org>
Date: Tue, 17 Jun 2014 15:08:24 -0500
X-Google-Sender-Auth: wWK7ziE7Qr7os9_B3P-Efngj-Iw
Message-ID: <CAL_Jsq+TFKJN_-PowcAyYztXzcomeAiT70xg7FxKgEQoG=7tAw@mail.gmail.com>
Subject: Re: Problems with commit 9ec36cafe4 (of/irq: do irq resolution in
 platform_get_irq) and mfd client devices
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 1:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Hi,
>
> I have an mfd master and client drivers on a system which has devicetree
> enabled. The mfd master driver passes interrupts to the clients using
> mfd cells and 'struct resource'. The client driver is a platform driver
> which retrieves the irq using platform_get_irq().
>
> After commit 9ec36cafe (of/irq: do irq resolution in platform_get_irq),
> this code no longer works. This is because platform_get_irq() does no
> longer call platform_get_resource() if OF is enabled and if dev->of_node
> is not NULL (it is not NULL because there is other [static] information
> which is passed to the client with devicetree data).
>
> Any idea how to solve this problem ? How do I now pass a virtual interrupt
> from an mfd master to its clients if devicetree is enabled ?

The node ptr points to the MFD node or a child node? If there are
child nodes in DT, then why not define interrupts there too? If there
are not child nodes, then perhaps the child drivers should not have DT
knowledge.

Does it fail to get an interrupt or gets the parent interrupt instead?

We could probably make an error fall-back to looking at resources. Or
try to get irq from resources first, then call of_irq_get.

Rob
