Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaGGPfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:35:22 -0400
Received: from smtp-out-167.synserver.de ([212.40.185.167]:1249 "EHLO
	smtp-out-166.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751458AbaGGPfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:35:20 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12531
Message-ID: <53BABDF6.4090400@metafoo.de>
Date: Mon, 07 Jul 2014 17:34:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Fabio Estevam <festevam@gmail.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
References: <20140706070800.GA2927@himangi-Dell> <20140707144832.GL30458@sirena.org.uk> <alpine.DEB.2.10.1407071655171.4757@hadrien> <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com> <alpine.DEB.2.10.1407071721270.4757@hadrien>
In-Reply-To: <alpine.DEB.2.10.1407071721270.4757@hadrien>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:23 PM, Julia Lawall wrote:
>
>
> On Mon, 7 Jul 2014, Fabio Estevam wrote:
>
>> On Mon, Jul 7, 2014 at 11:58 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>>
>>> Nevertheless, there is already a call to devm_regulator_bulk_get in
>>> sgtl5000_enable_regulators which calls sgtl5000_replace_vddd_with_ldo
>>> which calls ldo_regulator_register.  That call was introduced by
>>>
>>> commit 63e54cd9caa3ce03635810608519e2b37d8bc706
>>> Author: Fabio Estevam <fabio.estevam@freescale.com>
>>> Date:   Thu Apr 24 14:13:08 2014 -0300
>>>
>>> It seems that that patch should be reverted?
>>
>> I think so. Russell also reported a kernel oops when unbinding this
>> module, so I will prepare a patch reverting it.
>
> There is documentation about what kinds of devm functions exist, but it is
> too bad that there is no documentation about where they can be used.
> Often there are several levels of function pointers involved, so it can be
> hard to figure out whether they can be used just by looking at the code.
> I have only taken the strategy of using them in kinds of functions where
> someone else has alreadyy figured out that they can be used.

Yes, it is probably a bit underdocumented. The rule of thumb is don't use it 
anywhere else except for device probe callbacks (and functions that are only 
called from a device probe function) and only for the device that is being 
probed. There are probably a couple of instances in the kernel where the 
manged resource allocators are used in places where they shouldn't be used.

- Lars

