Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158Ab3DBOYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:24:55 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42117 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760885Ab3DBOYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:24:54 -0400
Message-ID: <1364912689.3399.7.camel@host5.opentask.org>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Tue, 02 Apr 2013 18:24:49 +0400
In-Reply-To: <515ADEDE.3050707@intel.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	 <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	 <87620jmkoe.fsf@octavius.laptop.org>
	 <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	 <87ppylf429.fsf@octavius.laptop.org> <515ADEDE.3050707@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 16:36 +0300, Adrian Hunter wrote:
> On my system it is significant:
> 
> Before the patch:
> 
> [    1.625623] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
> 
> After the patch:
> 
> [    1.935851] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
> 
> That is an addition of 310 ms which is 19% performance degradation.

Are you sure the delay is caused by mmc?

On my intel laptop (userspace is Debian/unstable):
[    1.542339] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
...
[    2.735851] mmc0: new high speed SD card at address e624
[    2.742289] mmcblk0: mmc0:e624 SU02G 1.84 GiB 
[    2.752317]  mmcblk0: p1

> Please revert the patch.

Chris, could provide a pointer on how to improve the patch?

Maybe introduce mmc_is_hosting_root() and do something like:

-	mmc_flush_scheduled_work();
+	if (mmc_is_hosting_root())
+		mmc_flush_scheduled_work();

