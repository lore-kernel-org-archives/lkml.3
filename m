Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaDORJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:09:55 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61377 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDORJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:09:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrFyBLtL6dVgFy6DkY0gdCjiVpk1OhsfUXD0nhajCetxg@mail.gmail.com>
References: <1397172708-19735-1-git-send-email-tim.kryger@linaro.org>
	<CAPDyKFrFyBLtL6dVgFy6DkY0gdCjiVpk1OhsfUXD0nhajCetxg@mail.gmail.com>
Date: Tue, 15 Apr 2014 10:09:53 -0700
Message-ID: <CAAYSxho=S5TqSU4uOiSuH-yh-O6tQxbKEzCn6ow=PLDBKPiSpQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: Set ocr_avail directly based on vmmc
From: Tim Kryger <tim.kryger@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        Linux MMC Mailing List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 1:15 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> I have seen some patches around lately touching the code for handling
> the regulators (vcc and vccq) in sdhci.

Was it this patch you were thinking of or something else?

http://www.spinics.net/lists/linux-mmc/msg25640.html

> A few times I have suggested to switch to use the
> mmc_regulator_get_supply() API to simplify and consolidate code. Could
> you please have a look at that?

This function will solve my problem but it also suggests that SDHCI
drivers should use the vmmc/vqmmc pointers in the mmc_host struct
rather than the ones in the sdhci_host struct.

Is this your intent?  Do you want to see the regulator pointers in the
sdhci_host struct removed once all drivers are modified to use the
mmc_host ones?

-Tim
