Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3CKNbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:31:07 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:35197 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3CKNbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
References: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
Date: Mon, 11 Mar 2013 21:31:03 +0800
Message-ID: <CACVXFVNuJa0i9gtUWP2tVexwjKF0k1MJ2bA9V5M28LUWFJt5DQ@mail.gmail.com>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
From: Ming Lei <tom.leiming@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 12:50 AM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> As it was described by Oliver Neukum in commit acbe2fe
> "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
>
>   Memory allocations with GFP_KERNEL can cause IO to a storage device
>   which can fail resulting in a need to reset the device. Therefore
>   GFP_KERNEL cannot be safely used between usb_lock_device()
>   and usb_unlock_device(). Replace by GFP_NOIO.
>
> The patch fixes the same issue in usb/core/devio.c.
> All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().

I am wondering why the device lock is needed for usbdev_do_ioctl()? Looks
device lock isn't required for USB transfer of kernel driver.


Thanks,
-- 
Ming Lei
