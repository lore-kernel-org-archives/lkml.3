Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaIJSvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:51:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53557 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaIJSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:51:23 -0400
Message-ID: <54109DA9.4070208@codeaurora.org>
Date: Wed, 10 Sep 2014 11:51:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] ARM: perf: Don't sleep while atomic when enabling per-cpu
 interrupts
References: <1410200814-25878-1-git-send-email-sboyd@codeaurora.org> <20140909113943.GG1754@arm.com> <540F3EE5.90500@codeaurora.org> <20140910182137.GL1710@arm.com>
In-Reply-To: <20140910182137.GL1710@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 11:21, Will Deacon wrote:
> On Tue, Sep 09, 2014 at 06:54:45PM +0100, Stephen Boyd wrote:
>
>> Here's the interdiff. Is there a reason arm64 casts data to an unsigned
>> int pointer when what's passed is an int pointer?
> There has to be a cast to something because data is a void *.
> enable_percpu_irq takes an unsigned int, so I guess that's why it was
> chosen. I'm not fussed either way.

Right, I'm just annoyed that what's passed in the void * is not an
unsigned int, it's an int. I agree that eventually we'll hand it to
enable_percpu_irq and there it will be implicitly casted to an unsigned
int so it really doesn't matter.

>
> Feel free to submit the full patch with my ack:
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>

Ok thanks.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

