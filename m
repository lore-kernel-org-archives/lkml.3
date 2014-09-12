Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaILOAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:00:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaILOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:00:12 -0400
Message-ID: <5412FC69.8080709@codeaurora.org>
Date: Fri, 12 Sep 2014 10:00:09 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>  <1410522513-1045-3-git-send-email-pawel.moll@arm.com>  <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
In-Reply-To: <1410526672.16936.52.camel@hornet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 08:57 AM, Pawel Moll wrote:
> On Fri, 2014-09-12 at 13:43 +0100, Christopher Covington wrote:
>> Just to ask the dumb questions in case the answers I've come up with are
>> wrong: What is PAGE_SIZE on an arm64 kernel? 
> 
> It's either 4 or 64k, depending on CONFIG_ARM64_64K_PAGES.
> 
>> How does userspace know?
>>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main(void)
> {
> 	printf("%ld\n", sysconf(_SC_PAGESIZE));
> 	return 0;
> }

Oh excellent, that actually works. Based on a misreading of the glibc code I
thought it was hard-coded to 64K.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
