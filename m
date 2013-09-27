Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3I0NVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:21:12 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752423Ab3I0NVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:21:10 -0400
Message-ID: <52458644.5040900@nod.at>
Date: Fri, 27 Sep 2013 15:21:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: fastmap: fix backward compatibility with image_seq
References: <1380286316-29911-1-git-send-email-richard.genoud@gmail.com> <52458377.7040100@nod.at> <CACQ1gAjcoW=mKS97t0HPYP6NXy92Cwm5YFriydPcke3N6LoB_A@mail.gmail.com>
In-Reply-To: <CACQ1gAjcoW=mKS97t0HPYP6NXy92Cwm5YFriydPcke3N6LoB_A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2013 15:16, schrieb Richard Genoud:
> 2013/9/27 Richard Weinberger <richard@nod.at>:
>> Am 27.09.2013 14:51, schrieb Richard Genoud:
>>> Some old UBI implementations (e.g. U-Boot) have not implemented the image
>>> sequence feature.
>>> So, when erase blocks are written, the image sequence in the ec header
>>> is lost (set to zero).
>>> UBI scan_all() takes this case into account (commits
>>> 32bc4820287a1a03982979515949e8ea56eac641 and
>>> 2eadaad67b2b6bd132eda105128d2d466298b8e3)
>>>
>>> But fastmap scan functions (ubi_scan_fastmap() and scan_pool()) didn't.
>>>
>>> This patch fixes the issue.
>>>
>>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>>> ---
>>
>> W00t! Good catch!
>>
>> Acked-by: Richard Weinberger <richard@nod.at>
> Thanks :)
> 
> 
> There's still an error when the image sequence is bad:
> [   35.632812] UBI error: scan_pool: bad image seq: 0x0, expected: 0x6e452f03
> [   35.640625] UBI error: ubi_scan_fastmap: Attach by fastmap failed,
> doing a full scan!
> [   35.648437] kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still
> has objects  <- the destroy_ai in line 1415

*grrr*, the problem here is that not all allocations which are done via
kmem_cache_alloc(ai->aeb_slab_cache, ...) got kfree()'d.

Thanks,
//richard
