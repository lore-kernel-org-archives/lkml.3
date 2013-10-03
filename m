Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3JCPIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:08:47 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570Ab3JCPIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:08:45 -0400
Message-ID: <524D8879.1030203@nod.at>
Date: Thu, 03 Oct 2013 17:08:41 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] UBI: fix refill_wl_user_pool()
References: <1380376516-30144-1-git-send-email-richard@nod.at>  <1380376516-30144-2-git-send-email-richard@nod.at> <1380812414.27358.440.camel@sauron.fi.intel.com>
In-Reply-To: <1380812414.27358.440.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.10.2013 17:00, schrieb Artem Bityutskiy:
> On Sat, 2013-09-28 at 15:55 +0200, Richard Weinberger wrote:
>> If no free PEBs are available refill_wl_user_pool() must not
>> return with -ENOSPC immediately.
>> It has to block till produce_free_peb() produced a free PEB.
>>
>> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> What is pool size, I wonder?

Currently it's 25 (UBI_FM_WL_POOL_SIZE).
If experience shows that 25 is too low/big we can change this constant.
Maybe it's also worth making them configurable...

Thanks,
//richard
