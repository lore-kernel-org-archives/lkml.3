Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3E0G5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:57:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2665 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3E0G5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:57:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 26 May 2013 23:57:16 -0700
Message-ID: <51A30372.6080907@nvidia.com>
Date: Mon, 27 May 2013 09:55:46 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com> <1368791388-31441-3-git-send-email-amerilainen@nvidia.com> <20130526101243.GB1652@mithrandir>
In-Reply-To: <20130526101243.GB1652@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 01:12 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Fri, May 17, 2013 at 02:49:44PM +0300, Arto Merilainen wrote:
>> Syncpoint wait returned EAGAIN if it was called with zero timeout.
>> This patch modifies the function to return ETIMEDOUT.
>
> This description is a bit redundant, because it repeats in prose what
> the code does. I'd rather see a description of why the change is
> necessary.

True. Will fix.

>
> Thinking about it, maybe it would be good to have two separate error
> codes. Keeping -EAGAIN for the case where a zero timeout was passed
> doesn't sound too bad to differentiate it from the case where a non-
> zero timeout was passed and it actually timed out. What do you think?

I agree, in this case it would not look bad at all. However, user space 
libraries may loop until the ioctl return code is something else than 
-EAGAIN or -EINTR. Especially function drmIoctl() in libdrm does this 
which is why I noted this isssue in the first place.

If user space uses zero timeout to just check if a syncpoint value has 
already passed the library continues looping until the syncpoint value 
actually passes. Of course, we could just modify the ioctl interface to 
"cast" this return code to something else but that does not seem correct.

- Arto
