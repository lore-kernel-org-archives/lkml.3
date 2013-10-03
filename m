Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3JCQir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:38:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60659 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3JCQip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:38:45 -0400
Subject: Re: Use of drivers/platform and matching include?
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131003162519.GA25042@kroah.com>
Date: Thu, 3 Oct 2013 11:38:44 -0500
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DAB5B812-4615-4107-AE29-FB8152634D9D@codeaurora.org>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <20131003152715.GA15931@kroah.com> <B674A07C-F8FE-4F4D-BB0A-87D5A50852D0@codeaurora.org> <20131003162519.GA25042@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 3, 2013, at 11:25 AM, Greg Kroah-Hartman wrote:

> On Thu, Oct 03, 2013 at 11:21:10AM -0500, Kumar Gala wrote:
>> 
>> On Oct 3, 2013, at 10:27 AM, Greg Kroah-Hartman wrote:
>> 
>>> On Thu, Oct 03, 2013 at 09:45:38AM -0500, Kumar Gala wrote:
>>>> As we look at upstreaming more support for the Qualcomm MSM SoCs there
>>>> are a number of drivers or library like routines that are unique to
>>>> the MSM platform, we are thinking that putting them under:
>>>> 
>>>> drivers/platform/qcom/
>>> 
>>> What type of drivers are these?  Shouldn't they really go under the
>>> specific driver type directory instead?
>> 
>> If there isn't an existing driver/ dir for this I dont see how it can go there, I'm not also not really a fan of trying to artificial put something that is highly SoC specific into something generic of this nature.
> 
> Loose a line-wrap somewhere?...
> 
> Anyway, you didn't answer my question, so why do I need to answer yours?

Sorry about that.  I gave one example in the initial email about a driver that is used to get regions of memory used by processors or HW blocks on the SoC.

I'm still sorting through the mass of code to figure out what all is there and where might be the best place for it.  However, I do think we will end up with some SoC specific bits that highly unique to qualcomm SoCs that just dont fit anywhere else and thus drivers/platforms seemed the best location.

As we submit things upstream I'm more than happy to move stuff around based on feedback.

One example you can look at is arch/arm/mach-msm/smd.c, this is a mix of the memory region support (which we've since split out) and some multiproc messaging functionality.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

