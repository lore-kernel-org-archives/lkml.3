Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbaH0FwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:52:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:56159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbaH0FwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:52:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473044301"
Message-ID: <53FD7210.606@linux.intel.com>
Date: Wed, 27 Aug 2014 08:52:16 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/2] regmap: cache: Fix regcache_sync_block
 for	non-autoincrementing devices
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>	<1409061793-10495-2-git-send-email-jarkko.nikula@linux.intel.com> <s5hk35vpc18.wl-tiwai@suse.de>
In-Reply-To: <s5hk35vpc18.wl-tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 05:21 PM, Takashi Iwai wrote:
> At Tue, 26 Aug 2014 17:03:12 +0300,
> Jarkko Nikula wrote:
>> Commit 75a5f89f635c ("regmap: cache: Write consecutive registers in a single
>> block write") expected that autoincrementing writes are supported if
>> hardware has a register format which can support raw writes.
>>
>> This is not necessarily true and thus for instance rbtree sync can fail when
>> there is need to sync multiple consecutive registers but block write to
>> device fails due not supported autoincrementing writes.
>>
>> Fix this by spliting raw block sync to series of single register writes for
>> devices that don't support autoincrementing writes.
> Wouldn't it suffice to correct regmap_can_raw_write() to return false
> if map->use_single_rw is set?
>
I don't know. I was thinking that also but was unsure about it since 
regcache_sync_block_raw() and regcache_sync_block_single() code paths 
use different regmap write functions. regcache_sync_block_raw() ends up 
calling _regmap_raw_write() which takes care of page select operation 
when needed and regcache_sync_block_single() uses _regmap_write() which 
doesn't.

Which makes me thinking should the regcache_sync_block_single() also use 
_regmap_raw_write() in order to take care of page selects?

-- 
Jarkko
