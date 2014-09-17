Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaIQOT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:19:27 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52381 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:19:26 -0400
Message-ID: <5419986A.9000302@martingkelly.com>
Date: Wed, 17 Sep 2014 07:19:22 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org, mingo@redhat.com, vishwesh.m.rudramuni@intel.com,
        joe@perches.com, hpa@linux.intel.com, aubrey.li@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com> <20140917122427.GB2704@gmail.com>
In-Reply-To: <20140917122427.GB2704@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 05:24 AM, Ingo Molnar wrote:
> 
> Just to paint the bike shed a bit, this could be further 
> simplified to something like:
> 
> 	...
> 
>   	ret = pmc_dbgfs_register(pmc, pdev);
>   	if (ret)
>   		iounmap(pmc->regmap);
> 
>   	return ret;
> 
> and then your patch will be perfect! :-)
> 

Yes, good idea. I sent a v3 with that implemented.
