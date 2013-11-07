Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3KGW5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:57:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51484 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3KGW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:57:06 -0500
Message-ID: <527C1AC0.2040206@codeaurora.org>
Date: Thu, 07 Nov 2013 14:57:04 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org> <20131106015645.GA28769@kroah.com> <527AD802.6020902@codeaurora.org> <20131107030640.GD8482@kroah.com>
In-Reply-To: <20131107030640.GD8482@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2013 7:06 PM, Greg KH wrote:
> On Wed, Nov 06, 2013 at 04:00:02PM -0800, Olav Haugan wrote:
>> On 11/5/2013 5:56 PM, Greg KH wrote:
>>> On Tue, Nov 05, 2013 at 04:54:12PM -0800, Olav Haugan wrote:
>>>> zsmalloc encodes a handle using the page pfn and an object
>>>> index. On some hardware platforms the pfn could be 0 and this
>>>> causes the encoded handle to be 0 which is interpreted as an
>>>> allocation failure.
>>>
>>> What platforms specifically have this issue?
>>
>> Currently some of Qualcomm SoC's have physical memory that starts at
>> address 0x0 which causes this problem.
> 
> Then say this, and list the exact SoC's that can have this problem so
> people know how to evaluate the bugfix and see if it is relevant for
> their systems.
> 
>> I believe this could be a problem
>> on any platforms if memory is configured to be starting at physical
>> address 0x0 for these platforms.
> 
> Have you seen this be a problem?  So it's just a theoretical issue at
> this point in time?

Yes, I can consistently reproduce it. It is not just theoretical.

Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
