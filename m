Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaGQMgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:36:52 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60303 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaGQMgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:36:50 -0400
Date: Thu, 17 Jul 2014 08:36:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dcb314@hotmail.com
Subject: Re: [PATCH 1/3] drivers/ata/pata_ep93xx.c: use signed int type for
 result of platform_get_irq()
Message-ID: <20140717123647.GA21390@htj.dyndns.org>
References: <1405599203-11113-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405599203-11113-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 03:13:23PM +0300, Andrey Utkin wrote:
> [linux-3.16-rc5/drivers/ata/pata_ep93xx.c:929]: (style) Checking if unsigned
> variable 'irq' is less than zero.
> 
> Source code is
> 
>     irq = platform_get_irq(pdev, 0);
>     if (irq < 0) {
> 
> but
> 
>     unsigned int irq;
> 
> $ fgrep platform_get_irq `find . -name \*.h -print`
> ./include/linux/platform_device.h:extern int platform_get_irq(struct
> platform_device *, unsigned int);
> 
> Now using "int" type instead of "unsigned int" for "irq" variable.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80401
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Applied to libata/for-3.16-fixes.

Thanks.

-- 
tejun
