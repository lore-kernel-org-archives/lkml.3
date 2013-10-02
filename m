Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3JBKqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:46:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18321 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3JBKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:46:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Oct 2013 03:46:51 -0700
Message-ID: <524BFF31.9080404@nvidia.com>
Date: Wed, 2 Oct 2013 16:40:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        =?ISO-8859-1?Q?Heiko_St=FCb?= =?ISO-8859-1?Q?ner?= 
	<heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for
 BIAS_DEFAULT
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com> <524454F3.8000402@wwwdotorg.org>	<52458876.4070205@nvidia.com> <5245AD0C.7070206@wwwdotorg.org> <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
In-Reply-To: <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 04:10 PM, Linus Walleij wrote:
> On Fri, Sep 27, 2013 at 6:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Presumably given this, LinusW shouldn't have actually applied this
> patch, since presumably it prevents any other driver from accepting
> PIN_CONFIG_BIAS_DISABLE even in cases where it is appropriate?
> There are many patches I shouldn't have applied ...
>
> Anyway I'm not quite following, this patch affected the Palmas
> driver only I think so how can it prevent any other drivers from doing
> the right thing?
>
> We'll just have to follow up with a patch that return -EINVAL for
> PIN_CONFIG_BIAS_DISABLE I guess, Laxman is this what you're
> doing now?
>

Yes, I am going to remove this option so that it can fall to default 
where it says

dev_err(pci->dev, "Properties not supported\n");
return -ENOTSUPP;


Will post the patch soon.

Thanks,
Laxman
