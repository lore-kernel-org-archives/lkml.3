Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaLZJT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:19:56 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39993 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaLZJTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:19:53 -0500
MIME-Version: 1.0
In-Reply-To: <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
	<877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 26 Dec 2014 10:19:52 +0100
Message-ID: <CACna6rx7k6cNkiu_OoEDr3Vvfo+GOtD9BLB6X1+oDNKz-AFg8Q@mail.gmail.com>
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than
 80 characters per line.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 08:20, Kalle Valo <kvalo@codeaurora.org> wrote:
> Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:
>
>> Three lines with more than 80 characters per line have been split in several lines.
>>
>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>> ---
>>  drivers/bcma/driver_chipcommon.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> Just to handle the bureaucracy before v2 is submitted:
>
> To which tree should this go to? I see that earlier John has applied
> patches to drivers/bcma/, but what about now? Should I take these? John,
> any suggestions?

bcma is a bus with multiple cores (devices)

As some of cores (devices) are very simply to handle and/or they are
needed very early (e.g. for initialization), bcma has:
1) Few bult-in drivers (like MIPS, ChipCommon)
2) Few "external" drivers using standard bus mechanism (e.g. b43,
brcmsmac, bgmac)

I guess the biggest bcma users are wireless drivers, so bcma was also
maintained using wireless tree. Unfortunately bus can't be just setup
once and not touched anymore. Drivers often need to touch ChipCommon
so there are some export_symbol-s in driver_chipcommon.c and you also
can get patchset-s touching bcma and then wireless driver.

Of course there are some problems with such maintenance. Rarely I've
to do changes in arch/mips/bcm47xx/ code, wait for a release and then
change sth in drivers/bcma. But I don't see a better solution for all
of this.

-- 
Rafał
