Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaDPH0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:26:50 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41514 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaDPH0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAAYSxho=S5TqSU4uOiSuH-yh-O6tQxbKEzCn6ow=PLDBKPiSpQ@mail.gmail.com>
References: <1397172708-19735-1-git-send-email-tim.kryger@linaro.org>
	<CAPDyKFrFyBLtL6dVgFy6DkY0gdCjiVpk1OhsfUXD0nhajCetxg@mail.gmail.com>
	<CAAYSxho=S5TqSU4uOiSuH-yh-O6tQxbKEzCn6ow=PLDBKPiSpQ@mail.gmail.com>
Date: Wed, 16 Apr 2014 09:20:57 +0200
Message-ID: <CAPDyKFp+xTbLtMip847wn1XM_ZJNix_TgQ6Psjq4RrB9=CWThw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: Set ocr_avail directly based on vmmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        Linux MMC Mailing List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 19:09, Tim Kryger <tim.kryger@linaro.org> wrote:
> On Fri, Apr 11, 2014 at 1:15 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
>> I have seen some patches around lately touching the code for handling
>> the regulators (vcc and vccq) in sdhci.
>
> Was it this patch you were thinking of or something else?
>
> http://www.spinics.net/lists/linux-mmc/msg25640.html

Yes, that's one of them. I am not sure I remember correct, but I think
there were patches for converting to devm_* API as well.

>
>> A few times I have suggested to switch to use the
>> mmc_regulator_get_supply() API to simplify and consolidate code. Could
>> you please have a look at that?
>
> This function will solve my problem but it also suggests that SDHCI
> drivers should use the vmmc/vqmmc pointers in the mmc_host struct
> rather than the ones in the sdhci_host struct.
>
> Is this your intent?  Do you want to see the regulator pointers in the
> sdhci_host struct removed once all drivers are modified to use the
> mmc_host ones?

Correct. That will consolidate code!

Then if sdhci has some special needs for regulators, let's first see
if we can adopt the API to handle it, before we decide to put that
code in sdhci driver.

Kind regards
Uffe

>
> -Tim
