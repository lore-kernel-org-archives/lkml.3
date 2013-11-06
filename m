Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3KFXqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:46:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57779 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3KFXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:46:44 -0500
Message-ID: <527AD4E2.6080706@codeaurora.org>
Date: Wed, 06 Nov 2013 15:46:42 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>,
        David Cohen <david.a.cohen@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>	<52799891.7070300@linux.intel.com> <CAPkvG_ftpPJMdYdOmKdYT2e6sd+tntX_vrvpLbAW85dXYJiQdw@mail.gmail.com>
In-Reply-To: <CAPkvG_ftpPJMdYdOmKdYT2e6sd+tntX_vrvpLbAW85dXYJiQdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2013 12:56 PM, Nitin Gupta wrote:
> On Tue, Nov 5, 2013 at 5:17 PM, David Cohen
> <david.a.cohen@linux.intel.com> wrote:
>> Hi Olav,
>>
>>
>> On 11/05/2013 04:54 PM, Olav Haugan wrote:
>>>
>>> zsmalloc encodes a handle using the page pfn and an object
>>> index. On some hardware platforms the pfn could be 0 and this
>>> causes the encoded handle to be 0 which is interpreted as an
>>> allocation failure.
>>>
>>> To prevent this false error we ensure that the encoded handle
>>> will not be 0 when allocation succeeds.
>>>
>>> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
>>> Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
>>> ---
>>>   drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
>>> b/drivers/staging/zsmalloc/zsmalloc-main.c
>>> index 523b937..0e32c0f 100644
>>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>>> @@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page,
>>> unsigned long obj_idx)
>>>         }
>>>
>>>         handle = page_to_pfn(page) << OBJ_INDEX_BITS;
>>> -       handle |= (obj_idx & OBJ_INDEX_MASK);
>>> +       handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
>>
>>
>> As suggestion you could use a macro instead of hardcoded 1.
>>
>> I am not familiar with this code, but if it's a valid test to verify if
>> the resulting address is page aligned, you might want to set this
>> offset macro to a page aligned value as well.
>>
>>
> 
> Using a hardcoded 1 looks fine in this case. But the patch description
> should also be added as a comment for this function. Otherwise, the patch
> looks good to me.
> 

Sure, I can add a comment above obj_location_to_handle() and
obj_handle_to_location().


Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
