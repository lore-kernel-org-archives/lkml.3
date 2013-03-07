Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab3CGFV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 00:21:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8863 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3CGFVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 00:21:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="28001108"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] ssbi: Fix exit mismatch in remove function
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
	<1362616187-21089-4-git-send-email-davidb@codeaurora.org>
	<20130307013042.GB2910@kroah.com>
Date: Wed, 06 Mar 2013 21:21:54 -0800
In-Reply-To: <20130307013042.GB2910@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 7 Mar 2013 09:30:42 +0800")
Message-ID: <8yaobevvl71.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Mar 06, 2013 at 04:29:44PM -0800, David Brown wrote:
>> msm_ssbi_remove is referenced with __exit_p, but not declared with
>> __exit.  This causes a warning when the driver is not built as a
>> module:
>> 
>> drivers/ssbi/ssbi.c:341:23: warning: 'msm_ssbi_remove' defined but not used [-Wunused-function]
>> 
>> Fix by adding the __exit declaration to the function.
>> 
>> Signed-off-by: David Brown <davidb@codeaurora.org>
>> ---
>>  drivers/ssbi/ssbi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
>> index 86d8416..4d503da 100644
>> --- a/drivers/ssbi/ssbi.c
>> +++ b/drivers/ssbi/ssbi.c
>> @@ -337,7 +337,7 @@ err_get_mem_res:
>>  	return ret;
>>  }
>>  
>> -static int msm_ssbi_remove(struct platform_device *pdev)
>> +static int __exit msm_ssbi_remove(struct platform_device *pdev)
>
> No, remove the __exit_p marking instead, unless you want your kernel to
> be oopsed :)

Thanks.  Oopsing is not fun.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
