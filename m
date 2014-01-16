Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaAPQSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:18:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaAPQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:18:19 -0500
Date: Thu, 16 Jan 2014 08:18:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, broonie@kernel.org
Subject: Re: [PATCH] tty: Fallback to use dynamic major number
Message-ID: <20140116161841.GA7476@kroah.com>
References: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:33:22AM +0530, Tushar Behera wrote:
> In a multi-platform scenario, the hard-coded major/minor numbers in
> serial drivers may conflict with each other. A typical scenario is
> observed with amba-pl011 and samsung-uart drivers, both of these
> drivers use same set of major/minor numbers. If both of these drivers
> are enabled, probe of samsung-uart driver fails because the desired
> node is busy.

Why would both drivers ever be loaded at the same time?  Don't they bind
to different hardware devices, and as such, never will be in the same
system?

The driver shouldn't be registering it's tty devices if the hardware
isn't present in the system, so how can this codepath ever happen?

> The issue is fixed by adding a fallback in driver core, so that we can
> use dynamic major number in case device node allocation fails for
> hard-coded major/minor number.

Did you test this out?  You still get userspace breakage with it :(

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Hi Greg,
> 
> This is my second attempt at getting this fixed. Let me know if you are
> okay with this.
> 
> Initial approach to fix this problem was by forcing samsung-uart driver
> to use dynamic major number, but it was rejected [1] because of possible
> user-space breakage.

"possible"?  Heh, no, that should be "real".

Sorry, but I think you are trying to fix a problem that never actually
happens in real life, or in valid configurations...

greg k-h
