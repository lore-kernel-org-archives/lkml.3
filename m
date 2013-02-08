Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947034Ab3BHWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:03:54 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60462 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3BHWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:03:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] Link platform device resources properly.
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <1358443596-30631-1-git-send-email-panto@antoniou-consulting.com>
References: <1358443596-30631-1-git-send-email-panto@antoniou-consulting.com>
Date: Fri, 08 Feb 2013 22:03:48 +0000
Message-Id: <20130208220348.CBEC03E2C27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 19:26:36 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> The resources of the platform devices created by the OF core were
> not properly linked. Make sure that they are, so that we don't get
> any crashes when trying to remove the device.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/device.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 4c74e4f..d75fcaf 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -62,6 +62,9 @@ int of_device_add(struct platform_device *ofdev)
>  	if (!ofdev->dev.parent)
>  		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
>  
> +	/* make sure we add the resources to the appropriate lists */
> +	platform_device_link_resources(ofdev);
> +
>  	return device_add(&ofdev->dev);
>  }

As mentioned in the other thread, I've got a patch in my tree that
obsoletes this change.

g.

