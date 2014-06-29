Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaF2OkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:40:21 -0400
Received: from mout.gmx.net ([212.227.15.19]:59854 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaF2OkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:40:20 -0400
Message-ID: <53B02551.9040907@gmx.de>
Date: Sun, 29 Jun 2014 16:40:17 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lib/argv_split.c : should argv be kfree'ed ?
References: <53AF3925.7070300@gmx.de> <20140628220421.GA24883@mguzik.redhat.com>
In-Reply-To: <20140628220421.GA24883@mguzik.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ZhXxrksqxp2IP1+J4P/E7cP2A/43vsRyVJ3rzPTESFquwWDiazk
 NSkwHPe+d+7TB1sAFf7cLPV+Dmc7XiU7DdUUOspn3l2L53IivvFHp0jNp0uoVX3hPliDRgP
 IQF8IJbROrthCvIyiWwS0URQ9Wljc3Wpr1W8AeBK+5R0GOXco0veKiXytttIzbX3RUlbd+l
 O/4Ux0N4PTXSIP4btlsPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 12:04 AM, Mateusz Guzik wrote:
> On Sat, Jun 28, 2014 at 11:52:37PM +0200, Toralf Förster wrote:
>> /me wonders if this patch is needed here :
>>
>>
>> diff --git a/lib/argv_split.c b/lib/argv_split.c
>> index e927ed0..7de4cb4 100644
>> --- a/lib/argv_split.c
>> +++ b/lib/argv_split.c
>> @@ -85,6 +85,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
>>                         *argv++ = argv_str;
>>                 }
>>         }
>> +       kfree (argv);
>>         *argv = NULL;
>>
>>         if (argcp)
>>
> 
> No, see argv_free.
> 
Ah, understood, it is in the responsibility of the caller to avoid the memleak.
BTW may I ask you about your opinion about this warning of cppcheck in lib/flex_array.c:

        for (part_nr = start_part; part_nr <= end_part; part_nr++) {<--- Memory leak: part
                part = __fa_get_part(fa, part_nr, flags);
                if (!part)
                        return -ENOMEM;
        }
        return 0;

-- 
Toralf

