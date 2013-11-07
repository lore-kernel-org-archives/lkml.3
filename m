Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3KGAAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:00:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58650 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3KGAAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:00:03 -0500
Message-ID: <527AD802.6020902@codeaurora.org>
Date: Wed, 06 Nov 2013 16:00:02 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org> <20131106015645.GA28769@kroah.com>
In-Reply-To: <20131106015645.GA28769@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/2013 5:56 PM, Greg KH wrote:
> On Tue, Nov 05, 2013 at 04:54:12PM -0800, Olav Haugan wrote:
>> zsmalloc encodes a handle using the page pfn and an object
>> index. On some hardware platforms the pfn could be 0 and this
>> causes the encoded handle to be 0 which is interpreted as an
>> allocation failure.
> 
> What platforms specifically have this issue?

Currently some of Qualcomm SoC's have physical memory that starts at
address 0x0 which causes this problem. I believe this could be a problem
on any platforms if memory is configured to be starting at physical
address 0x0 for these platforms.

>>
>> To prevent this false error we ensure that the encoded handle
>> will not be 0 when allocation succeeds.
>>
>> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
> 
> What is this?  What can anyone do with it?

This is an identifier used by "Gerrit Code Review" to track changes to
the same patch. I will remove it.

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
