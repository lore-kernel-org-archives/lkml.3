Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaACWIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:08:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55642 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaACWIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:08:54 -0500
Message-ID: <52C734F4.5020602@codeaurora.org>
Date: Fri, 03 Jan 2014 14:08:52 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 00/11] Intermix Lowmem and vmalloc
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org> <52C70024.1060605@sr71.net>
In-Reply-To: <52C70024.1060605@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/2014 10:23 AM, Dave Hansen wrote:
> On 01/02/2014 01:53 PM, Laura Abbott wrote:
>> The goal here is to allow as much lowmem to be mapped as if the block of memory
>> was not reserved from the physical lowmem region. Previously, we had been
>> hacking up the direct virt <-> phys translation to ignore a large region of
>> memory. This did not scale for multiple holes of memory however.
>
> How much lowmem do these holes end up eating up in practice, ballpark?
> I'm curious how painful this is going to get.
>

In total, the worst case can be close to 100M with an average case 
around 70M-80M. The split and number of holes vary with the layout but 
end up with 60M-80M one hole and the rest in the other.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
