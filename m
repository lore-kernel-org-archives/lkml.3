Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaIDVxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:53:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61577 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaIDVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:53:36 -0400
X-AuditID: cbfee68f-f797f6d000001173-d2-5408df5d9d9a
Message-id: <5408DF5D.4020808@samsung.com>
Date: Fri, 05 Sep 2014 06:53:33 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Addy Ke <addy.ke@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mmc: dw_mmc: Don't enable interrupts until we're ready
References: <1409701034-28526-1-git-send-email-dianders@chromium.org>
 <5407F6F1.60900@samsung.com>
 <CAD=FV=WfCmC=jPDv0annedsP2KVJ5Na=+EYGJXv-9+NSfN30_w@mail.gmail.com>
In-reply-to: <CAD=FV=WfCmC=jPDv0annedsP2KVJ5Na=+EYGJXv-9+NSfN30_w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkUDf2PkeIwaxt1hbL/n9nsphweTuj
	xdllB9ksNj2+xmpxedccNosj//sZLZ6cmclo8eH+RWaL42vDHTg9ZjdcZPG4c20Pm8fmJfUe
	N14tZPL4O2s/i0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBl3F43h6VgtlzF91l7GBsYT4p3
	MXJySAiYSBy5uY4NwhaTuHBvPZDNxSEksJRR4uDuA0wwRXduPWOHSExnlNj8Yg0LhPOaUeLu
	kp2sIFW8AloSM48+Ze5i5OBgEVCVmP4pCyTMJqAjsf3bcbBBogJhEofa5jFBlAtK/Jh8jwXE
	FhHQlHjW8JIZZCazQDOzxJHt18FmCgt4S7ScO88KsWw1o8TC17PZQRKcAsES3c/bwe5mFlCX
	mDRvETOELS+xec1bsEkSAh/ZJSbs2MUIkmAREJD4NvkQC8h1EgKyEpsOMEO8JilxcMUNlgmM
	YrOQHDULydhZSMYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREYn6f/PevfwXj3gPUh
	RgEORiUe3oIX7CFCrIllxZW5hxhNga6YyCwlmpwPTAJ5JfGGxmZGFqYmpsZG5pZmSuK8C6V+
	BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgVJ9z9Vxhlfoj0Yedh2UVz6hETNqcPG3rkW3+
	28VOHbjYlb0se+YjaTXe6PyFm+oebnMI7S2SOFopaXp+V4KMg4fLg9+HvRVfvJlv8mLLhxqp
	ita4Yxrn/605lXby6Z8bJ1LVn07JdRFyOtY80YTRwFpviarI0lXcTckZNw0U74VkTcv9c/zI
	cSWW4oxEQy3mouJEAEvvWWXKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG7sfY4Qg2P/jSyW/f/OZDHh8nZG
	i7PLDrJZbHp8jdXi8q45bBZH/vczWjw5M5PR4sP9i8wWx9eGO3B6zG64yOJx59oeNo/NS+o9
	brxayOTxd9Z+Fo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmHF73RyWgtlyFd9n7WFsYDwp3sXIySEhYCJx59YzdghbTOLCvfVsXYxcHEIC0xklNr9Y
	wwLhvGaUuLtkJytIFa+AlsTMo0+Zuxg5OFgEVCWmf8oCCbMJ6Ehs/3acCcQWFQiTONQ2jwmi
	XFDix+R7LCC2iICmxLOGl8wgM5kFmpkljmy/DjZTWMBbouXceVaIZasZJRa+ng12EqdAsET3
	83Y2EJtZQF1i0rxFzBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI7+Z1I7GFc2WBxiFOBgVOLhLXjBHiLEmlhWXJl7iFGCg1lJhPfDXY4QId6U
	xMqq1KL8+KLSnNTiQ4ymwCCYyCwlmpwPTEx5JfGGxiZmRpZG5oYWRsbmSuK8B1qtA4UE0hNL
	UrNTUwtSi2D6mDg4pRoYzxTwnK9pTF1+a/sjIbaPj7crGW7WsfhxeuL2igcvZ4l5rROevP74
	cqElWeILhM/8j1I7/HH/yflHPlidWi93b3bors+Nyq5xK93/JgtJOsW+Zp7QGefotuDxBG+L
	/CcZivenGM74a6npu7JLJzT8wHftu1pcNpN+vn/1I0nXsN2yQjpt78lp/5VYijMSDbWYi4oT
	AQSVTLcUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On 09/05/2014 04:21 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Wed, Sep 3, 2014 at 10:21 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Doug
>>
>> On 09/03/2014 08:37 AM, Doug Anderson wrote:
>>> On dw_mmc there's a small race if you happen to get a card detect
>>> interrupt at just the wrong time during probe.  You may have enabled
>>> the interrupt but host->slot[0] may be NULL.
>>>
>>> Fix the race by enabling interrupts all the way at the end of the
>>> probe.  We can also use free_irq() instead of dw_mmc specific masking
>>> to mask the IRQ at removal time.  Note that since we're now managing
>>> freeing of the irq ourselves, there's no need to use devm.
>>>
>>> FYI, the crash would look like:
>>>   dwmmc_rockchip ff0c0000.dwmmc: DW MMC controller at irq 64, 32 bit host data width, 256 deep fifo
>>>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>>>   pgd = c0004000
>>>   [00000000] *pgd=00000000
>>>   ...
>>>   ...
>>>   [<c0499380>] (dw_mci_work_routine_card) from [<c0134b94>] (process_one_work+0x260/0x3c4)
>>>   [<c0134b94>] (process_one_work) from [<c0135b10>] (worker_thread+0x240/0x3a8)
>>>   [<c0135b10>] (worker_thread) from [<c013b64c>] (kthread+0x100/0x118)
>>>   [<c013b64c>] (kthread) from [<c0106418>] (ret_from_fork+0x14/0x20)
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> ---
>>> FYI: making dw_mmc into a module and trying module removal was not
>>> tested.  I'd appreciate any testing that folks can do there.  This
>>> code should be the equivalent and makes the error case of probe match
>>> the removal case more closely now.
>>>
>>>  drivers/mmc/host/dw_mmc.c | 17 +++++++++++------
>>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index 7f227e9..540ba3c 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -2577,10 +2577,6 @@ int dw_mci_probe(struct dw_mci *host)
>>>               goto err_dmaunmap;
>>>       }
>>>       INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>>> -     ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
>>> -                            host->irq_flags, "dw-mci", host);
>>> -     if (ret)
>>> -             goto err_workqueue;
>>>
>>>       if (host->pdata->num_slots)
>>>               host->num_slots = host->pdata->num_slots;
>>> @@ -2619,11 +2615,21 @@ int dw_mci_probe(struct dw_mci *host)
>>>               goto err_workqueue;
>>>       }
>>>
>>> +     ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags,
>>> +                       "dw-mci", host);
>>> +     if (ret)
>>> +             goto err_initted;
>>
>> I didn't test and consider race condition yet.
>> But if located "request_irq" at here, we can be confused something,
>> since there is "dev_info(host->dev, "%d slots initialized\n", init_slots)" message at above.
>>
>> I think you can relocate this.
> 
> OK, good point.  Maybe we should skip this patch after all.  There is
> definitely a race there, but I'm not 100% sure this is the right fix
> for it.

I'm not sure this patch is fixed for it, too.
So i will check more with your patch.
But i think if we can maintain current status, it will be the best.

Best Regards,
Jaehoon Chung

> 
> In general we probably need to look at the dw_mci_work_routine_card()
> a bit more (used for card detect) since that's only used for official
> "CD" lines.  ...and as we've talked about anyone who wants to properly
> power their card off should be using GPIOs, thus they won't get the
> benefit of whatever dw_mci_work_routine_card() does.
> 
> I did play around a little bit with trying to test the module remove.
> Both before and after my patch it hung.
> 
> -Doug
> 

