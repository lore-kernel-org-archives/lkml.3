Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaGaFgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:36:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37410 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaGaFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:36:34 -0400
Message-ID: <53D9D5DD.6030603@codeaurora.org>
Date: Thu, 31 Jul 2014 11:06:29 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: BUG when __kmap_atomic_idx crosses boundary
References: <1406710355-4360-1-git-send-email-cpandya@codeaurora.org> <20140730020615.2f943cf7.akpm@linux-foundation.org>
In-Reply-To: <20140730020615.2f943cf7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 02:36 PM, Andrew Morton wrote:
> On Wed, 30 Jul 2014 14:22:35 +0530 Chintan Pandya<cpandya@codeaurora.org>  wrote:
>
>> __kmap_atomic_idx>= KM_TYPE_NR or<  ZERO is a bug.
>> Report it even if CONFIG_DEBUG_HIGHMEM is not enabled.
>> That saves much debugging efforts.
>
> Please take considerably more care when preparing patch changelogs.
Okay. I will prepare new commit message.
>
> kmap_atomic() is a very commonly called function so we'll need much
> more detail than this to justify adding overhead to it.
>
> I don't think CONFIG_DEBUG_HIGHMEM really needs to exist.  We could do
> s/CONFIG_DEBUG_HIGHMEM/CONFIG_DEBUG_VM/g and perhaps your secret bug
> whatever it was would have been found more easily.
Um, we didn't get bug directly hitting here.
>

__kmap_atomic_idx should not be equal to KM_TYPE_NR anyway. So, at least 
I will share that patch. For changing DEBUG_HIGHMEM to DEBUG_VM, I will 
work on it.

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
