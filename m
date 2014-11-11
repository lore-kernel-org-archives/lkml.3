Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaKKIPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:51 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaKKIPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:47 -0500
Message-ID: <5461C5AD.5040705@nod.at>
Date: Tue, 11 Nov 2014 09:15:41 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org> <5460F7D8.2030100@nod.at>
In-Reply-To: <5460F7D8.2030100@nod.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.11.2014 um 18:37 schrieb Richard Weinberger:
> Am 03.11.2014 um 14:58 schrieb Tanya Brokhman:
>> If there is more then one UBI device mounted, there is no way to
>> distinguish between messages from different UBI devices.
>> Add device number to all ubi layer message types.
>>
>> The R/O block driver messages were replaced by pr_* since
>> ubi_device structure is not used by it.
>>
>> Amended a bit by Artem.
>>
>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> I've rebased my fastmap work to linux-ubifs.git which contains this patch.
> While testing I noticed that the log output looks quite different.
> 
> e.g.
> [   26.564111] UBI-0: ubi_attach_mtd_dev:default fastmap pool size: 256
> [   26.565438] UBI-0: ubi_attach_mtd_dev:default fastmap WL pool size: 128
> [   26.566781] UBI-0: ubi_attach_mtd_dev:attaching mtd0 to ubi0
> [   26.653704] UBI-0: scan_all:scanning is finished
> [   26.654379] UBI-0: late_analysis:empty MTD device detected
> [   26.761154] UBI-0: ubi_attach_mtd_dev:attached mtd0 (name "NAND simulator partition 0", size 128 MiB)
> [   26.762112] UBI-0: ubi_attach_mtd_dev:PEB size: 16384 bytes (16 KiB), LEB size: 15872 bytes
> [   26.762933] UBI-0: ubi_attach_mtd_dev:min./max. I/O unit sizes: 512/512, sub-page size 256
> [   26.763765] UBI-0: ubi_attach_mtd_dev:VID header offset: 256 (aligned 256), data offset: 512
> [   26.764607] UBI-0: ubi_attach_mtd_dev:good PEBs: 8192, bad PEBs: 0, corrupted PEBs: 0
> [   26.765394] UBI-0: ubi_attach_mtd_dev:user volume: 0, internal volumes: 1, max. volumes count: 92
> [   26.766244] UBI-0: ubi_attach_mtd_dev:max/mean erase counter: 0/0, WL threshold: 4096, image sequence number: 3297366243
> [   26.767287] UBI-0: ubi_attach_mtd_dev:available PEBs: 8014, total reserved PEBs: 178, PEBs reserved for bad PEB handling: 160
> [   26.769050] UBI-0: ubi_thread:background thread "ubi_bgt0d" started, PID 2686
> [   29.119991] UBI-0: ubi_detach_mtd_dev:detaching mtd0
> [   29.121084] UBI-0: ubi_thread:background thread "ubi_bgt0d" should stop, PID 2686
> [   29.165538] UBI-0: ubi_detach_mtd_dev:mtd0 is detached
> 
> Do we really want the function name in every log message?
> IMHO this is not wise except for pure debug logs.

BTW: Why UBI-X? This looks odd. Either use UBIX or ubiX.

Thanks,
//richard
