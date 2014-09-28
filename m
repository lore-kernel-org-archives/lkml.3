Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaI1Iyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:54:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaI1Iyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:54:52 -0400
Message-ID: <5427CCD8.2090605@nod.at>
Date: Sun, 28 Sep 2014 10:54:48 +0200
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
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <5427C45C.2080506@nod.at> <5427CB6E.7010007@codeaurora.org>
In-Reply-To: <5427CB6E.7010007@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.09.2014 10:48, schrieb Tanya Brokhman:
>>> @@ -424,6 +440,8 @@ struct ubi_fm_sb {
>>>       __be32 used_blocks;
>>>       __be32 block_loc[UBI_FM_MAX_BLOCKS];
>>>       __be32 block_ec[UBI_FM_MAX_BLOCKS];
>>> +    __be32 block_rc[UBI_FM_MAX_BLOCKS];
>>> +    __be64 block_let[UBI_FM_MAX_BLOCKS];
>>
>> Doesn't this break the fastmap on-disk layout?
> 
> What do you mean "break"? I verified fastmap feature is working. the whole read-disturb depends on it so I tested this thoroughly.

Did you write a fastmap with your changes applied and then an attach using a fastmap implementation *without*
you changes?
I bet it will not work because the disk layout is now different.
Linux is not the only user of fastmap. We need to be very careful here.

Thanks,
//richard
