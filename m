Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbbA2PBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:01:51 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46750 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbbA2PBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150129151711.454100be@endymion.delvare>
References: <20150126112328.318da5e7@endymion.delvare>
	<CAPDyKFo363x7NGEctNwHkpn-6HkAu15qu-ZFtt73mJcWZrce4g@mail.gmail.com>
	<1422369244.4499.187.camel@chaos.site>
	<CAPDyKFqWa0uyZStNT1Wp21HpSqYpfJx3wU3TDJy25uMgG7qZaw@mail.gmail.com>
	<20150129151711.454100be@endymion.delvare>
Date: Thu, 29 Jan 2015 16:01:48 +0100
Message-ID: <CAPDyKFohbn3yG9iuj7WbV0mDY4H4jZe3SgihGSdOqPLKkTMdZQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: Add hardware dependencies for sdhci-pxav3 and sdhci-pxav2
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2015 at 15:17, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Ulf,
>
> On Wed, 28 Jan 2015 15:04:24 +0100, Ulf Hansson wrote:
>> On 27 January 2015 at 15:34, Jean Delvare <jdelvare@suse.de> wrote:
>> > Hi Ulf,
>> >
>> > Le Tuesday 27 January 2015 à 15:06 +0100, Ulf Hansson a écrit :
>> >> On 26 January 2015 at 11:23, Jean Delvare <jdelvare@suse.de> wrote:
>> >> > I seem to understand that the sdhci-pxav3 and sdhci-pxav2 drivers are
>> >> > only needed on the MMP architecture. So add a hardware dependency on
>> >> > ARCH_MMP, so that other users don't get to build useless drivers.
>> >>
>> >> I would rather see the default option to be N.
>> >> Thus those configurations that needs this driver will have to select it.
>> >
>> > This is a different question. The purpose of my patch is that people
>> > configuring kernels for systems which just can't have these controllers,
>> > are not asked about this driver at all. Changing the default to N would
>> > not achieve that.
>>
>> For those SOC that want these drivers, they should be able to select
>> them from their defconfigs. So it will be an opt-in instead of opt-out
>> policy, which I prefer. It also follows the other Kconfig options for
>> mmc drivers.
>
> As you wish. But that change would be a separate patch going on top of
> mine, right? I'm not sure I understand what you expect from me at this
> point, please clarify.

Sorry for being unclear. I don't like $subject patch.

Send a new one, removing the following lines:
default CPU_MMP2
default CPU_PXA910

Then you send another patch(es) to the respective SOC maintainer,
updating the defonfig(s) selecting MMC_SDHCI_PXAV3|PXAV2, when
appropriate.

Would that work?

Kind regards
Uffe
