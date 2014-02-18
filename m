Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBRUUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:20:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaBRUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:20:40 -0500
Date: Tue, 18 Feb 2014 12:22:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dt: platform driver: Fill the resources before probe and
 defer if needed
Message-ID: <20140218202205.GA13835@kroah.com>
References: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392285429-9325-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:57:09AM +0100, Jean-Jacques Hiblot wrote:
> The goal of this patch is to allow drivers to be probed even if at the time of
> the DT parsing some of their ressources are not available yet.
> 
> In the current situation, the resource of a platform device are filled from the
> DT at the time the device is created (of_device_alloc()). The drawbackof this
> is that a device sitting close to the top of the DT (ahb for example) but
> depending on ressources that are initialized later (IRQ domain dynamically
> created for example)  will fail to probe because the ressources don't exist
> at this time.
> 
> This patch fills the resource structure only before the device is probed and
> will defer the probe if the resource are not available yet.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/base/platform.c     |  6 ++++
>  drivers/of/platform.c       | 71 +++++++++++++++++++++++++++++----------------
>  include/linux/of_platform.h | 10 +++++++
>  3 files changed, 62 insertions(+), 25 deletions(-)

I need some others to ack this before I can take it...

