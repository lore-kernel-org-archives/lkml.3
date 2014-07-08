Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaGHMJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:09:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaGHMJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:09:31 -0400
Message-ID: <53BBDF78.40708@suse.cz>
Date: Tue, 08 Jul 2014 14:09:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Ronald <ronald645@gmail.com>
CC: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression: firmware: Simplify directory creation + b43 = fails
 to build
References: <CAF1_xX2oeG0YCLaLZR9ZUY2qiD0-sVB6L10dZppnae7iZV_U3g@mail.gmail.com>	<53A1A354.7030107@suse.cz>	<CAF1_xX38AWEK5sW8v_RrL=HzAg7JRNyCzgKNuZFzCGV4y2O7Og@mail.gmail.com> <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
In-Reply-To: <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-07 21:02, Torsten Kaiser wrote:
> On Wed, Jun 18, 2014 at 6:25 PM, Ronald <ronald645@gmail.com> wrote:
>> From my .config
>>
>>  ==> cat /usr/src/config | grep -i b43
>> CONFIG_EXTRA_FIRMWARE="b43/ucode5.fw b43/b0g0initvals5.fw
>> b43/b0g0bsinitvals5.fw b43/pcm5.fw"
>> ... snip ...
> 
> That might be rather later, but I seem to have the same problem:
>   CHK     kernel/config_data.h
>   MK_FW   firmware/amd-ucode/microcode_amd.bin.gen.S
> /bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
> [...]
> The directory firmware/amd-ucode does not exist in the kernel source
> tree, but my .config seems to need it:
> CONFIG_EXTRA_FIRMWARE="radeon/R700_rlc.bin radeon/RV710_uvd.bin
> radeon/RV730_smc.bin amd-ucode/microcode_amd.bin"
> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
> 
> Just doing a "mkdir firmware/amd-ucode" lets the build continue and I
> get a working 3.16 kernel.
> 
> With 3.15 and earlier I never had a problem with this, but 3.16-rc4
> just failed with above message.
> 
> Do you need my full .config or any other information about my system?

That's not needed, I can reproduce the failure now as well.

Michal
