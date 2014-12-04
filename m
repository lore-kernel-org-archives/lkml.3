Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaLDMh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:37:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44027 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaLDMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:37:56 -0500
Message-ID: <548055A0.3020703@codeaurora.org>
Date: Thu, 04 Dec 2014 14:37:52 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/35] UBI: Fix stale pointers in ubi->lookuptbl
References: <1414586758-9972-1-git-send-email-richard@nod.at> <1414586758-9972-3-git-send-email-richard@nod.at> <54803EBF.9060609@codeaurora.org> <54803FC0.7080305@nod.at>
In-Reply-To: <54803FC0.7080305@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/2014 1:04 PM, Richard Weinberger wrote:
> Tanya,
>
> Am 04.12.2014 um 12:00 schrieb Tanya Brokhman:
>> Hi Richard
>>
>> On 10/29/2014 2:45 PM, Richard Weinberger wrote:
>>> In some error paths the WL sub-system gives up on a PEB
>>> and frees it's ubi_wl_entry struct but does not set
>>> the entry in ubi->lookuptbl to NULL.
>>> Fastmap can stumble over such a stale pointer as it uses
>>> ubi->lookuptbl to find all PEBs.
>>>
>>> Fix this by setting the pointers to free'd ubi_wl_entry to NULL.
>>
>> There are 2 more places:
>> tree_destroy() and protection_queue_destroy() where ubi_wl_entry is released. Both functions used on power down so all should be good as is, just wanted to make sure you didn't add
>> ubi->lookuptbl[e2->pnum] = NULL there on purpose.
>
> I fear you're looking at the old patch series.
> Please have a look at:
> "[PATCH 3/6] UBI: Fix stale pointers in ubi->lookuptbl" sent on 30.11.2014.
>
> Thanks,
> //richard
>

oh, you're right. Started from the oldest. now I see you released v2. 
Sorry. So I should be looking at "Fastmap update v2 (pile 1-7)", right?

Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
