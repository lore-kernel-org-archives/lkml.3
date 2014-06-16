Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaFPRHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:07:19 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34340 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaFPRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp7ccn8yJqgs=49V32injEBG=95ANh1vHKXKpS9OyJvXQ@mail.gmail.com>
References: <1402679637-27611-1-git-send-email-markus.mayer@linaro.org>
	<1402679637-27611-3-git-send-email-markus.mayer@linaro.org>
	<CAPDyKFp7ccn8yJqgs=49V32injEBG=95ANh1vHKXKpS9OyJvXQ@mail.gmail.com>
Date: Mon, 16 Jun 2014 10:06:56 -0700
Message-ID: <CAPdLdq=o-n3LGcsXfiM59TQo9kNq36uN+ZVL1dma17MWaTSCNg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mmc: sdhci: Replace host->mmc with mmc where possible
From: Markus Mayer <markus.mayer@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Tim Kryger <tim.kryger@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2014 01:23, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 13 June 2014 19:13, Markus Mayer <markus.mayer@linaro.org> wrote:
>> After the switch to the MMC core regulator infrastucture, we already
>> have a local "mmc" pointer in various functions. There is no longer a
>> need to access the data structure via host->mmc.
>>
>> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Matt Porter <mporter@linaro.org>
>
> Could you run checkpatch? There were some warnings to handle.

You're right. There are several warnings regarding wrapped strings.
However, those warnings are unrelated to my changes. The wrapped
strings exist in current code.

See for instance:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/mmc/host/sdhci.c?id=refs/tags/v3.16-rc1#n1730

I don't think I should intermix my "host->mmc to mmc" replacement
patch with changes to fix the wrapping of strings.

If you would like these string related checkpatch warnings fixed, I
can look into creating a follow-on patch to fix those up. There are
quite a few more instances in sdhci.c that wouldn't get addressed if I
simply fixed up my existing patch. And that would be the other
argument against intermixing 2 different fixes: I wouldn't be taking
care of all string wrapping issues if I just fixed the four instances
it complains about in my patch.

Some of those wrapped strings are actually quite long. Here's an example:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/mmc/host/sdhci.c?id=refs/tags/v3.16-rc1#n1938

So, fixing those long messages may take a bit more thought than one
might initially expect.

Please let me know how you would like to proceed.

Thanks,
-Markus
