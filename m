Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3JXMDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:03:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58907 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3JXMDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:03:14 -0400
Message-ID: <52690C7B.9070908@ti.com>
Date: Thu, 24 Oct 2013 15:03:07 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regmap: debugfs: Fix a boot time crash with early regmap
 init
References: <1382605668-31395-1-git-send-email-t-kristo@ti.com> <20131024091857.GG31415@sirena.org.uk>
In-Reply-To: <20131024091857.GG31415@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 12:18 PM, Mark Brown wrote:
> On Thu, Oct 24, 2013 at 12:07:48PM +0300, Tero Kristo wrote:
>
>> +	if (!regmap_debugfs_root) {
>> +		struct regmap_debugfs_node *node;
>> +		node = kzalloc(sizeof(*node), GFP_KERNEL);
>> +		if (!node)
>> +			return;
>> +		node->map = map;
>> +		node->name = name;
>> +		list_add(&node->link, &regmap_debugfs_early);
>> +		return;
>> +	}
>> +
>
> init is somewhat parallel so I'd be happier if we locked the list to
> make sure that we don't corrupt the list.

Ok, I added a mutex for protection (later registration might take some 
time so didn't want to use spinlock.)

> We also need something to handle removal of items from the list if the
> regmap is destroyed prior to the initcall running (for example in error
> handling cases), otherwise we could end up creating debugfs files
> pointing at devices that no longer exist.

Added cleanup for the list in the regmap_debugfs_exit() call. Sending v2 
shortly.

-Tero
