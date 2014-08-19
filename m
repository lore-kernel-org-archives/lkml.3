Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaHSOa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:30:56 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56910 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHSOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:30:55 -0400
Message-ID: <53F35F94.1010101@gmail.com>
Date: Tue, 19 Aug 2014 16:30:44 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        t.figa@samsung.com, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com
Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com> <53D238E1.3030901@gmail.com> <002601cfaa11$93de5060$bb9af120$@samsung.com> <2491338.uD82s4TcKJ@amdc1032>
In-Reply-To: <2491338.uD82s4TcKJ@amdc1032>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On 18.08.2014 19:42, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday, July 28, 2014 08:40:52 AM Pankaj Dubey wrote:
>> Hi Tomasz,
>>
>> On Friday, July 25, 2014 Tomasz Figa wrote:
>>
>>> To: Pankaj Dubey; 'Kukjin Kim'; linux-arm-kernel@lists.infradead.org;
>> linux-
>>> samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Cc: linux@arm.linux.org.uk; t.figa@samsung.com; vikas.sajjan@samsung.com;
>>> joshi@samsung.com; naushad@samsung.com; thomas.ab@samsung.com;
>>> chow.kim@samsung.com
>>> Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for
>>> Exynos PMU
>>>
>>> Hi Pankaj, Kukjin,
>>>
>>> On 25.07.2014 07:32, Pankaj Dubey wrote:
>>>> Hi Kukjin,
>>>>
>>>> On Friday, July 25, 2014 Kukjin Kim wrote:
>>>
>>> [snip]
>>>
>>>>>>
>>>>> Looks good to me, will apply this and 4/4.
>>>>>
>>>>
>>>> We need to hold these two patches until dependent patch [1] from
>>>> Tomasz Figa gets merged.
>>>>
>>>> [1]: mfd: syscon: Decouple syscon interface from syscon devices
>>>>       https://lkml.org/lkml/2014/6/24/188
>>>
>>> That RFC patch had few comments from Arnd needed to be addressed, so it
>> needs a
>>> new revision.
>>>
>>> Pankaj, If I remember correctly, we had talked about this and the
>> conclusion was that
>>> you would take care of addressing the comments and sending new version of
>> the
>>> patch. Any update on this or have I missed something?
>>>
>>
>> Well, I don't think we concluded as such anything.
>> Since this patch needs to get in so that Exynos PMU and PM related changes
>> can go in,
>> I discussed with you saying that I am not able to understand about Arnd's
>> comments and
>> if possible and time permits I will look into it. Meanwhile I got busy with
>> some other
>> official work, so could not get time to look into it.
> 
> Tomasz/Pankaj, could we please get some agreement on what needs to be
> done and who should do the pending work?
> 
> syscon patch is blocking PMU cleanup patches which in turn are blocking
> PMU support additions for new SoCs (Exynos5420/5800 and Exynos3250 PMU
> patches).

Leaving alone the matter who is going to take care of it for now, the
remaining work to do is to further decouple syscon from struct device,
which means providing of_ API to register a syscon provider on a device
tree node even before driver model is available yet.

I believe it should be quite straightforward on top of my RFC and should
require only saving syscon's of_node directly in syscon struct, adding
appropriate API and extending the look-up loops to handle cases when
syscon's dev is NULL.

Best regards,
Tomasz
