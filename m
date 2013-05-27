Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3E0GVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:21:33 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6892 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3E0GVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:21:31 -0400
X-Greylist: delayed 134463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 02:21:30 EDT
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 26 May 2013 23:21:30 -0700
Message-ID: <51A2FB88.9000303@nvidia.com>
Date: Mon, 27 May 2013 11:52:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
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
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <1369405896-30246-3-git-send-email-kishon@ti.com> <51A2F07F.8070009@samsung.com> <51A2F512.2090907@ti.com> <51A2F84D.9030605@samsung.com>
In-Reply-To: <51A2F84D.9030605@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013 11:38 AM, Chanwoo Choi wrote:
> On 05/27/2013 02:54 PM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Monday 27 May 2013 11:04 AM, Chanwoo Choi wrote:
>>> Hi Kishon,
>>>
>>> I have some comment about this patch
>>> and upload modified patch to following repository (extcon-for-palmas).
>>> - http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-for-palmas&id=f2b7cb80699cbe1a5fd6c97ef2c600915f8d7f2c
>>>
>>> This patchset include patch related to other module
>>> ,so I need your opinion to apply this patchset to git repository.
>> yeah.. Still there is some confusion with palmas_set_switch_smps10(). I think we can remove it for now and add it separately later. By this at least we can have device mode fully functional in OMAP5. What do you think?
>>
>   I agree your opinion.
>
> But, I propose some fixes about palmas_set_switch_smps10().
> I dont' prefer to call global function in exton-palmas.c from palmas-regulator.c.
> So, Why don't you use regulator consumer instead of global function?
> You can register specific regulator for enabling or disabling SMPS10_SWITCH_EN
> and then control SMPS10_SWITCH_EN bit through regulator framework in extcon-palmas.c
> without calling global function.

Along with this, I also like to make the VBUS regulator control to be 
optional here. Currently it is mandatory.
