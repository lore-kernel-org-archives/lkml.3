Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaIZRTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:19:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47132 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaIZRTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:19:07 -0400
Message-ID: <5425A008.2030901@arm.com>
Date: Fri, 26 Sep 2014 18:19:04 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, "acme@redhat.com" <acme@redhat.com>
CC: Sudeep Holla <sudeep.holla@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] perf tools: fix build breakage on arm and arm64 targets
References: <1411750918-25220-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1411750918-25220-1-git-send-email-will.deacon@arm.com>
X-OriginalArrivalTime: 26 Sep 2014 17:19:03.0871 (UTC) FILETIME=[F87F84F0:01CFD9AD]
X-MC-Unique: 114092618190400401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26/09/14 18:01, Will Deacon wrote:
> Attempting to build the perf tool on arm or arm64 targets results in the
> following failure:
>
> arch/arm/util/unwind-libunwind.c: In function ‘libunwind__arch_reg_id’:
> arch/arm/util/unwind-libunwind.c:43:3: error: implicit declaration of function ‘pr_err’ [-Werror=implicit-function-declaration]
>     pr_err("unwind: invalid reg id %d\n", regnum);
>     ^
> This is due to commit 84f5d36f4866 ("perf tools: Move pr_* debug macros
> into debug object") moving the pr_* macros into a new header file, but
> failing to update architectures other than x86.
>
> This patch adds the missing includes, and fixes the build again.
>

For ARM64, we also need the patch[1] "perf tools: Fix arm64 build error" 
which is already queued in linux-next.

Regards,
Sudeep

[1] https://lkml.org/lkml/2014/6/24/1024

