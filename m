Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab3BGCYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:24:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3BGCYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:24:49 -0500
Date: Wed, 6 Feb 2013 18:28:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max8997: Add driver for max8997 rtc.
Message-Id: <20130206182817.3af25596.akpm@linux-foundation.org>
In-Reply-To: <511306BB.2020708@samsung.com>
References: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
	<20130206130615.86121923.akpm@linux-foundation.org>
	<511306BB.2020708@samsung.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013 10:43:23 +0900 jonghwa3.lee@samsung.com wrote:

> > The best way of handling this sort of thing is for the driver to probe
> > the hardware, work out its capabilities and "do the right thing".
> > 
> > The second best way is to require that the user add certain module
> > parameters to enable the functionality.
> > 
> 
> How do we create sysfs node for enabling these options?

I suggest using module_param[_named](), so users can execute "modprobe
max8997 wtsr=1".  Or, if the driver is built into vmlinux, add
"max8997.wtsr=1" to the kernel boot command line.

Documentation/kernel-parameters.txt mentions this.
