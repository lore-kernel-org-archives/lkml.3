Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3JaPYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3JaPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:24:20 -0400
Message-ID: <52727607.6050107@redhat.com>
Date: Thu, 31 Oct 2013 11:23:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk, x86@kernel.org,
        hmh@hmh.eng.br, andi@firstfloor.org
Subject: Re: [PATCH] x86, microcode, Fix long microcode load time when firmware
 file is missing [v2]
References: <1382961968-20067-1-git-send-email-prarit@redhat.com> <s5heh75wi4h.wl%tiwai@suse.de>
In-Reply-To: <s5heh75wi4h.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2013 11:05 AM, Takashi Iwai wrote:
> At Mon, 28 Oct 2013 08:06:08 -0400,
> Prarit Bhargava wrote:
>>
>> If no firmware is found on the system that matches the processor, the
>> microcode module can take hours to load.  For example on recent kernels
>> when loading the microcode module on an Intel system:
>>
>> [  239.532116] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x413
>> [  299.693447] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x413
>> [  359.821972] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x413
>> [  419.960263] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x413
>> [  480.090024] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> [ 2825.151364] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2885.280863] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2945.410719] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3005.540541] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3065.670405] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> etc.
>>
>> Similarly there is a 60 second "hang" when loading the AMD module, which
>> isn't as bad as the Intel situation.  This is because the AMD microcode
>> loader only attempts to look for the firmware on the boot_cpu and, if
>> found, loads the microcode on each cpu.  This patch does the same for the
>> Intel microcode, and it obviously peeds up the module load if there is no
>> microcode update available.
>>
>> After making this change, the old microcode loading code and the new
>> loading code can be cleaned up and unified in the core code.
>>
>> This patch was tested on several systems (both AMD and Intel) with the
>> microcode in place and without, as well as on several different OSes.
> 
> Does simply disabling CONFIG_FW_LOADER_USER_HELPER work without your
> patch?
> 
> If yes, it's an infamous udev issue.  An easier solution would be to
> create a function that does only the direct f/w loading without
> usermode helper, and call it in the microcode driver.
> 
> An untested quick fix patch is attached below.
> 
> 

Takashi, this patch works AFAICT.

I wish I had thought of doing it this way to begin with ...

If you choose to submit, can you add a Tested-by: Prarit Bhargava
<prarit@redhat.com>

Thanks,

P.
