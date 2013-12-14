Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3LNAx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:53:59 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40102 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3LNAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:53:58 -0500
Message-ID: <52ABAC22.5000309@linaro.org>
Date: Fri, 13 Dec 2013 16:53:54 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org> <1386973529-4884-2-git-send-email-john.stultz@linaro.org> <20131213235028.GA4919@kroah.com> <52AB9E51.2020807@linaro.org>
In-Reply-To: <52AB9E51.2020807@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 03:54 PM, John Stultz wrote:
> On 12/13/2013 03:50 PM, Greg KH wrote:
>> On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
>>> From: Rebecca Schultz Zavin <rebecca@android.com>
>>>
>>> Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
>>> [jstultz: Squished in Colin Cross' move to staging change]
>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>> ---
>>>  drivers/staging/android/Kconfig                 |    2 +
>>>  drivers/staging/android/Makefile                |    2 +
>> This patch breaks the build if this option is enabled.
>>
>> I suggest only adding the driver to the build _after_ it can be built,
>> for obvious reasons :)
> Right. Until recently it really only builds on ARM. There's a patch
> which adds that dependency (and then later removes it once other fixes
> land), but its later in the patch series.

Ah. Forgot about the shrinker interface changes (which I fix at the very
end).

So yea, I'll disable the config in the first patch ("depends on BROKEN"
good enough? or would you prefer "depends on BROKEN && !BROKEN" to be
really sure? ;), and then yank that line in the last.

thanks
-john
