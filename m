Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3CEIgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:36:48 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50723 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3CEIgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:36:47 -0500
Date: Tue, 5 Mar 2013 16:37:07 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
Message-ID: <20130305083707.GA7513@kroah.com>
References: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com>
 <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 06:44:36PM +0000, Serban Constantinescu wrote:
> Android's shared memory subsystem, Ashmem, does not support calls from a
> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
> coming from a 32bit userspace in a 64bit kernel.
> 
> The patch has been successfully tested on ARMv8 AEM(64bit
> platform model) and Versatile Express A9(32bit platform).
> 
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> Acked-by: Arve Hjønnevåg <arve@android.com>
> Acked-by: John Stultz <john.stultz@linaro.org>

This patch breaks the build on my machine:
drivers/staging/android/ashmem.c: In function ‘compat_ashmem_ioctl’:
drivers/staging/android/ashmem.c:711:7: error: ‘compat_size_t’ undeclared (first use in this function)
drivers/staging/android/ashmem.c:711:7: note: each undeclared identifier is reported only once for each function it appears in

so of course, I can't take it :(

greg k-h
