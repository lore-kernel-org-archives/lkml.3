Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JCQVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:21:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58924 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3JCQVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:21:10 -0400
Subject: Re: Use of drivers/platform and matching include?
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131003152715.GA15931@kroah.com>
Date: Thu, 3 Oct 2013 11:21:10 -0500
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B674A07C-F8FE-4F4D-BB0A-87D5A50852D0@codeaurora.org>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <20131003152715.GA15931@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 3, 2013, at 10:27 AM, Greg Kroah-Hartman wrote:

> On Thu, Oct 03, 2013 at 09:45:38AM -0500, Kumar Gala wrote:
>> As we look at upstreaming more support for the Qualcomm MSM SoCs there
>> are a number of drivers or library like routines that are unique to
>> the MSM platform, we are thinking that putting them under:
>> 
>> drivers/platform/qcom/
> 
> What type of drivers are these?  Shouldn't they really go under the
> specific driver type directory instead?

If there isn't an existing driver/ dir for this I dont see how it can go there, I'm not also not really a fan of trying to artificial put something that is highly SoC specific into something generic of this nature.

>> would make sense.  In addition there are headers that might need to
>> get shared with drivers in other locations so I wanted to see what the
>> take was on introducing:
>> 
>> include/linux/platform/qcom/
>> 
>> An example driver would be the means we utilize to communicate memory
>> regions between various HW blocks on the SoC.  So a video/media core
>> driver might need access to a header/functions from the memory region
>> driver.
> 
> Isn't there arch-specific include directories already that are good for
> stuff like this?

Well, we expect at some point in needing to share with arm64 as well so that causes issues (one of the reason I'm not a fan of the split between the two arch's).

- k
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

