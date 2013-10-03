Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3JCUfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:35:55 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:61429 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3JCUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGvFFu-MDQX4UNcfr58Jxg6BKkw=gAMqz0Vv6jV9miixfg@mail.gmail.com>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
	<CANEJEGvFFu-MDQX4UNcfr58Jxg6BKkw=gAMqz0Vv6jV9miixfg@mail.gmail.com>
Date: Thu, 3 Oct 2013 13:35:51 -0700
X-Google-Sender-Auth: K4cfMkzypN-zMGJXQXWlxyl5H9M
Message-ID: <CANEJEGtK+og5XeaCNtnVJhCPWmN1y78BX=yghc-8=kuV1+f=Xw@mail.gmail.com>
Subject: Re: [PATCH 0/7] mmc: core: cleanup and locking patches description
From: Grant Grundler <grundler@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.co>
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Has anyone had a chance to review/test this series and/or be willing
to do so this week?

grundler@firesword:~$ pwclient list -w 'grundler@chromium.org' -p LKML
Patches submitted by Grant Grundler <grundler@chromium.org>:
ID      State        Name
--      -----        ----
...
2950961 New          [1/7] mmc: core: rename "data" to saved_areq
2951081 New          [2/7] mmc: core: rename local var err to saved_err
2950981 New          [3/7] mmc: core: restructure error handling for start req
2951001 New          [4/7] mmc: core: use common code path to return error
2951061 New          [5/7] mmc: core: handling polling more gracefully
2951041 New          [6/7] mmc: core: protect references to host->areq
with host->lock
2951021 New          [7/7] mmc: core: mmc_start_req is a misnomer ->
mmc_process_areq


To remind, this is the fio command line that results in mmcqd hangs on
the exynos 5250 system (uses dw_mmc storage controller):

$FIO --name=short_randwrite --size=2G --time_based --runtime=90 \
        --readwrite=randwrite --numjobs=2 --bs=4k --norandommap
--ioengine=psync \
        --direct=0 --invalidate=1 --filename=/dev/mmcblk0p5

thanks,
grant

On Thu, Sep 26, 2013 at 12:57 PM, Grant Grundler <grundler@chromium.org> wrote:
> Argh...too much wordsmithing...
>
> On Thu, Sep 26, 2013 at 12:22 PM, Grant Grundler <grundler@chromium.org> wrote:
>> Following 7 patches are mostly cleanup with one key patch around host->areq
>> locking.  The host->areq locking problem description is here:
>>         http://www.spinics.net/lists/linux-mmc/msg21644.html
>>
>> I do believe this preposed host->areq locking patch is a complete fix.
>
> ... is NOT a complete fix.
>
>> But it appears to fix the problem and is better than nothing.
>
> Still true.
>
> cheers,
> grant
>
>>
>> This patch sequence applies clean to linus' 3.12-rc2 branch and only compile
>> tested in this form. This is a forward port (and cleanup) of the
>> same patch I've been testing on ChromeOS-3.4 tree using Exynos5250 chipset.
>>
>> cheers,
>> grant
>>
>> 0000-mmc-core-cleanups-and-locking-description (this email)
>> 0001-mmc-core-rename-data-to-saved_areq.patch
>> 0002-mmc-core-rename-local-var-err-to-saved_err.patch
>> 0003-mmc-core-restructure-error-handling-for-start-req.patch
>> 0004-mmc-core-use-common-code-path-to-return-error.patch
>> 0005-mmc-core-handling-polling-more-gracefully.patch
>> 0006-mmc-core-protect-references-to-host-areq-with-host-l.patch
>> 0007-mmc-core-mmc_start_req-is-a-misnomer-mmc_process_are.patch
>>
>>
>>  drivers/mmc/card/block.c    |   8 ++--
>>  drivers/mmc/card/mmc_test.c |   4 +-
>>  drivers/mmc/core/core.c     | 103 +++++++++++++++++++++++++-------------------
>>  include/linux/mmc/core.h    |   2 +-
>>  4 files changed, 66 insertions(+), 51 deletions(-)
