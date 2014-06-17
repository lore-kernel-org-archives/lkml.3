Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965813AbaFQQuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:50:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44166 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967AbaFQQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:04 -0400
Message-ID: <53A06B65.7030407@wwwdotorg.org>
Date: Tue, 17 Jun 2014 10:23:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-9-git-send-email-mperttunen@nvidia.com> <1470404.13mIFv0Hnj@amdc1032> <53A0686F.4000303@wwwdotorg.org> <20140617161320.GG31819@htj.dyndns.org> <20140617161447.GH31819@htj.dyndns.org>
In-Reply-To: <20140617161447.GH31819@htj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 10:14 AM, Tejun Heo wrote:
> On Tue, Jun 17, 2014 at 12:13:20PM -0400, Tejun Heo wrote:
>> On Tue, Jun 17, 2014 at 10:10:23AM -0600, Stephen Warren wrote:
>>>> sata_writel() and sata_read() static inlines don't seem to add any value.
>>>>
>>>> Can they be removed?
>>>
>>> Such functions are quite idiomatic in drivers, and serve to simplify all
>>> the call-sites by removing the need to write out the addition of the
>>> base address everywhere.
>>
>> I think it obfuscates more than helps.  If you absoluately have to
>> keep it, please at least name it so that it's clear that it's
>> something specific to this driver.
> 
> Please also drop inline.  It isn't a difficult optimization to perform
> for the compiler.

There are probably hundreds of drivers marking those functions inline.
If they aren't marked inline, it'll just stick out as unusual when
people read them all, and then they'll send patches to fix it.
