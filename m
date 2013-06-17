Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3FQX7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:59:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3FQX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:59:16 -0400
Date: Mon, 17 Jun 2013 16:59:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: fix use-after-free by double abort
Message-ID: <20130617235915.GA19162@kroah.com>
References: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 04:36:38PM +0800, Ming Lei wrote:
> fw_priv->buf is accessed in both request_firmware_load() and
> writing to sysfs file of 'loading' context, but not protected
> by 'fw_lock' entirely. The patch makes sure that access on
> 'fw_priv->buf' is protected by the lock.
> 
> So fixes the double abort problem reported by nirinA raseliarison:
> 
> 	http://lkml.org/lkml/2013/6/14/188
> 
> Reported-and-tested-by: nirinA raseliarison <nirina.raseliarison@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

So this is a 3.9-stable thing?  Anything newer than that?

thanks,

greg k-h
