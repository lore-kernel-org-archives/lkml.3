Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbA1UM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:12:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbA1UMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:21 -0500
Date: Wed, 28 Jan 2015 09:42:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] gpio: sysfs: fix gpio device-attribute leak
Message-ID: <20150128174222.GD7973@kroah.com>
References: <20150128012627.464883057@linuxfoundation.org>
 <1422461105-815-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422461105-815-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 05:05:05PM +0100, Johan Hovold wrote:
> commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.
> 
> The gpio device attributes were never destroyed when the gpio was
> unexported (or on export failures).
> 
> Use device_create_with_groups() to create the default device attributes
> of the gpio class device. Note that this also fixes the
> attribute-creation race with userspace for these attributes.
> 
> Remove contingent attributes in export error path and on unexport.
> 
> Fixes: d8f388d8dc8d ("gpio: sysfs interface")
> Cc: stable <stable@vger.kernel.org> # v2.6.27+
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> 
> Backport to v3.10 (and earlier) which lacks device_create_with_groups().
> 
> Changes since v1
>  - fix mistake in backport, which removed the attributes while holding
>    the mutex in gpiod_unexport (reported by Luis Henriques)

Thanks for the updated patch, now replaced the old one with this one.

greg k-h
