Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJBNYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:24:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaJBNYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:24:22 -0400
Message-ID: <542D5203.2080601@nod.at>
Date: Thu, 02 Oct 2014 15:24:19 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedeking1@gmail.com
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <5427C45C.2080506@nod.at> <5427CB6E.7010007@codeaurora.org> <5427CCD8.2090605@nod.at> <5427E6FE.3090906@codeaurora.org> <5427E8CA.8000904@nod.at> <542D49FD.7040204@codeaurora.org>
In-Reply-To: <542D49FD.7040204@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.10.2014 14:50, schrieb Tanya Brokhman:
>> Consider the case where you have a board with a fastmap enabled bootloader and a Linux OS.
>> The bootloader does a fastmap attach and boots the kernel from UBI and the kernel it self has the rootfs
>> on UBI too. If you install a new kernel with your changes applied it will write the fastmap in a different
>> format and the bootloader will fail badly. In worst case the board bricks, in best case the bootloader can fall back
>> to scanning mode but it will be slow and the customer unhappy.
>>
> 
> Ok, I understand the problem now. I wanted to discuss a possible solution before implementing it:
> We have a "fastmap version" in fm_sb. At the moment UBI_FM_FMT_VERSION = 1 and any other is not supported. We can use that; Add another fm version (UBI_FM_FMT_VERSION_RD = 2) and
> then decide according to it. Meaning, if during attach process we find fm superblock we check it's version, if it's != UBI_FM_FMT_VERSION_RD, we fall back to full scan. The next
> fastmap will be written with the new layout (and new version number) so second boot will attach from fastmap without any issues.

Yes, if we change the fastmap on-disk layout we need to change UBI_FM_FMT_VERSION.
Then other fastmap implementations will notice the change and can hopefully recover.
Implementations which do not evaluate UBI_FM_FMT_VERSION deserve breaking. ;-)

That said, I'll not block a layout change but we have to be sure that it is *really* needed.
I'm currently heavily working on fastmap and my local queue with fastmap fixes keeps growing.
If I find a horror bug which needs a fastmap layout change I want to change the layout only once,
not twice.

Thanks,
//richard
