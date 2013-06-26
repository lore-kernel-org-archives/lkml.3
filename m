Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3FZUjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:39:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37550 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3FZUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:39:21 -0400
Message-ID: <51CB5176.5000404@wwwdotorg.org>
Date: Wed, 26 Jun 2013 14:39:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 1/6] fbdev: simplefb: add init through platform_data
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-2-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-2-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 PM, David Herrmann wrote:
> If we create proper platform-devices in x86 boot-code, we can use simplefb
> for VBE or EFI framebuffers, too. However, there is normally no OF support
> so we introduce a platform_data object so x86 boot-code can pass the
> paramaters via plain old platform-data.
> 
> This also removes the OF dependency as it is not needed. The headers
> provide proper dummies for the case OF is disabled.
> 
> Furthermore, we move the FORMAT-definitions to the common platform header
> so initialization code can use it to transform "struct screen_info" to
> the right format-name.

> diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h

> +/* the framebuffer size and location is available as IORESOURCE_MEM */
> +struct simplefb_platform_data {
> +	u32 width;
> +	u32 height;
> +	u32 stride;
> +	char format[64];
> +};

Any reason not to make format:

const char *format;

You should be able to initialize that just as easily in platform code,
either as static data or at runtime, I think.
