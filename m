Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3E0GmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:42:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46208 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab3E0GmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:42:17 -0400
Message-ID: <51A30026.2090001@ti.com>
Date: Mon, 27 May 2013 12:11:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "george.cherian@ti.com" <george.cherian@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH v5 2/3] extcon: Palmas Extcon Driver
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <1369405896-30246-3-git-send-email-kishon@ti.com> <51A2F07F.8070009@samsung.com> <51A2F512.2090907@ti.com> <51A2F84D.9030605@samsung.com> <51A2FB88.9000303@nvidia.com> <51A2FDD2.10309@ti.com> <51A2FEE9.1060905@nvidia.com>
In-Reply-To: <51A2FEE9.1060905@nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 27 May 2013 12:06 PM, Laxman Dewangan wrote:
> On Monday 27 May 2013 12:01 PM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Monday 27 May 2013 11:52 AM, Laxman Dewangan wrote:
>>> On Monday 27 May 2013 11:38 AM, Chanwoo Choi wrote:
>>>> On 05/27/2013 02:54 PM, Kishon Vijay Abraham I wrote:
>>>>> Hi,
>>>>>
>>>>> On Monday 27 May 2013 11:04 AM, Chanwoo Choi wrote:
>>>>>> Hi Kishon,
>>>>>>
>>>>>> I have some comment about this patch
>>>>>> and upload modified patch to following repository
>>>>>> (extcon-for-palmas).
>>>>>> -
>>>>>> http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-for-palmas&id=f2b7cb80699cbe1a5fd6c97ef2c600915f8d7f2c
>>>>>>
>>>>>>
>>>>>>
>>>>>> This patchset include patch related to other module
>>>>>> ,so I need your opinion to apply this patchset to git repository.
>>>>> yeah.. Still there is some confusion with palmas_set_switch_smps10().
>>>>> I think we can remove it for now and add it separately later. By this
>>>>> at least we can have device mode fully functional in OMAP5. What do
>>>>> you think?
>>>>>
>>>>    I agree your opinion.
>>>>
>>>> But, I propose some fixes about palmas_set_switch_smps10().
>>>> I dont' prefer to call global function in exton-palmas.c from
>>>> palmas-regulator.c.
>>>> So, Why don't you use regulator consumer instead of global function?
>>>> You can register specific regulator for enabling or disabling
>>>> SMPS10_SWITCH_EN
>>>> and then control SMPS10_SWITCH_EN bit through regulator framework in
>>>> extcon-palmas.c
>>>> without calling global function.
>>> Along with this, I also like to make the VBUS regulator control to be
>>> optional here. Currently it is mandatory.
>> But dint you just tell on my v4 of this patch that you don’t require
>> this.
>> http://www.spinics.net/lists/linux-doc/msg10638.html
>
> In V4, I said remove this VBUS control and my mean was to remove all
> regulator calls for VBUS enabled/disable.
> I saw you just remove the platform data option to have this control and
> made VBUS mandatory.
>
> Probably some gap here.

Indeed..
I think then we should stick back to how it was with my v4 or else it 
would break OMAP. The regulator calls can't be moved anywhere else as it 
is specific to PALMAS.

Thanks
Kishon
