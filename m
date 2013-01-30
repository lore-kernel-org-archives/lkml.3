Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3A3HqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:46:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3A3HqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:46:20 -0500
Message-ID: <5108CFC1.8010905@gmail.com>
Date: Wed, 30 Jan 2013 15:46:09 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 3/4] drm: tegra: use the Common Display Framework
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-4-git-send-email-acourbot@nvidia.com> <5108C298.1000500@gmail.com> <5108C55C.30104@nvidia.com>
In-Reply-To: <5108C55C.30104@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 03:01 PM, Alex Courbot wrote:
> On 01/30/2013 03:50 PM, Mark Zhang wrote:
[...]
> 
>>> +    /* register display notifier */
>>> +    output->display_notifier.dev = NULL;
>>
>> Set "display_notifier.dev" to NULL makes we have to compare with every
>> display entity, just like what you do in "display_notify_callback":
>>
>> entity->dev && entity->dev->of_node == pnode
>>
>> So can we get the "struct device *" of panel here? Seems currently the
>> "of" framework doesn't allow "device_node -> device".
> 
> Nope. AFAICT the device might not be instanciated at this point. We
> become aware of it for the first time in the callback function. We also
> don't want to defer probing until the panel is parsed first, since the
> panel might also depend on resources of the display device.
> 

Agree.

> Thanks,
> Alex.
> 
