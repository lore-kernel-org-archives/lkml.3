Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3L0RnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:43:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59853 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3L0RnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:43:11 -0500
Date: Fri, 27 Dec 2013 12:43:09 -0500 (EST)
Message-Id: <20131227.124309.1704278577980085243.davem@davemloft.net>
To: levex@linux.com
Cc: linux-kernel@vger.kernel.org, federico.vaga@gmail.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 05/38] sparc: kernel: add missing put_device call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387465429-3568-6-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	<1387465429-3568-6-git-send-email-levex@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 27 Dec 2013 09:43:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Levente Kurusa <levex@linux.com>
Date: Thu, 19 Dec 2013 16:03:16 +0100

> This is required so that we give up the last reference to the device.
> The kfree() has been removed because put_device will set the underlying kref's
> reference count to zero and hence vio_dev_release will get called resulting in
> kfreeing the structure.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

There is no reference held to vdev->dev at this point, that's why
we should directly kfree() it and put_device() is not appropriate.

Pretty much all of your patches have this problem.
