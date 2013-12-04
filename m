Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3LDIam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:30:42 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:55217 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3LDIal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:30:41 -0500
Date: Wed, 4 Dec 2013 08:30:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix memory leak in mfd_add_devices()
Message-ID: <20131204083037.GE7469@lee--X1>
References: <1383058042-22706-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383058042-22706-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Geert Uytterhoeven wrote:

> If the first call to mfd_add_device() fails, no child devices have been
> registered to the parent yet, and thus mfd_remove_devices() won't find
> anything to remove nor free.
> Hence the previously allocated array of atomic_t objects will leak.
> 
> Free the array instead of calling mfd_remove_devices() on failure during
> the first loop iteration to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mfd/mfd-core.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Hmm... I didn't see my reply to this, but it has been applied for a
while.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
