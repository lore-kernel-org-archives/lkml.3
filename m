Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3CKPwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:52:11 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:60298 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3CKPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303111127030.2246-100000@iolanthe.rowland.org>
References: <CACVXFVNuJa0i9gtUWP2tVexwjKF0k1MJ2bA9V5M28LUWFJt5DQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1303111127030.2246-100000@iolanthe.rowland.org>
Date: Mon, 11 Mar 2013 23:52:08 +0800
Message-ID: <CACVXFVN6zm2gG4v1jhV=8EwAtKs=bg3urJ7dRiOgPGHtKXHYxA@mail.gmail.com>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:32 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Of course you have to lock the device before changing its driver.  What
> would happen if two different threads tried to change a device's driver
> at the same time?

Yes, claim/release interface need device lock, but the patch doesn't
touch claim/release command handling.

>
> usbdev_do_ioctl() needs to acquire the device lock in order to prevent
> races with driver_disconnect() and usbdev_remove().

Looks the patch basically converts the allocation inside URB submit path,
and actually I mean why we need to hold device lock in submitting
URB path?  Device lock isn't required before submitting URBs
in kernel driver.


Thanks,
-- 
Ming Lei
