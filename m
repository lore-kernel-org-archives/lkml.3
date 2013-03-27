Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3C0P6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:58:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40951 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3C0P6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:58:02 -0400
Message-ID: <51531706.4040608@wwwdotorg.org>
Date: Wed, 27 Mar 2013 09:57:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com> <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com>
In-Reply-To: <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 07:00 AM, Linus Walleij wrote:
> On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> 
>>  #ifdef CONFIG_OF_GPIO
>> -       palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
>> +       palmas_gpio->gpio_chip.of_node = pdev->dev.of_node;
>>  #endif
> 
> OK I think that #ifdef is necessary...

Laxman,

Don't we need to resolve and agree on the final DT bindings before we
can start making changes like this? It's not clear yet whether everyone
is on the same page re: how the MFD sub-devices are modelled in DT -
whether each sub-component really is a standalone device, or whether the
MFD itself instantiates all its children based on internal static tables
rather than DT.

Presumably, the answer to that question directly determines whether the
code change above is correct; the correct of_node might be either the
main Palmas node (if DT doesn't represent the MFD components) or it
might be the regulator sub-node (if DT is used to represent MFD components).

Given that, I'm not sure why the Slimlogic people aren't CC'd on this
patch:-(
