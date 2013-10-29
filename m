Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3J2T2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:28:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:55059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3J2T2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,595,1378882800"; 
   d="scan'208";a="424756017"
Message-ID: <52700D4C.10008@linux.intel.com>
Date: Tue, 29 Oct 2013 12:32:28 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>  <1383070766.12439.13.camel@joe-AO722> <526FFED4.4070902@linux.intel.com> <1383071755.12439.17.camel@joe-AO722>
In-Reply-To: <1383071755.12439.17.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 11:35 AM, Joe Perches wrote:
> On Tue, 2013-10-29 at 11:30 -0700, David Cohen wrote:
>> Hi Joe,
>>
>> On 10/29/2013 11:19 AM, Joe Perches wrote:
>>> On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
>>>> This patch adds driver for ssp spi interface on Intel Mid platform.
>>>
>>> A few simple notes:
>>>
>>> Please consider using checkpatch.
>>
>> I did and got no warnings. But haven't used --strict option.
>
> Interesting.  I thought there was a return (foo);
> statement that should have been marked, but I didn't
> actually run checkpatch.

It seems odd checkpatch didn't catch it. I'll investigate.

>
> static inline u32 is_rx_fifo_empty(struct ssp_drv_context *sspc)
> +{
> +       return ((read_SSSR(sspc->ioaddr) & SSSR_RNE) == 0);
> +}
>
> This could be bool too

u32 seems unusual, but I'd prefer 'int' if it's fine for you.

Br, David
