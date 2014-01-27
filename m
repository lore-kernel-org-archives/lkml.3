Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaA0VyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:54:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaA0VyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:54:10 -0500
Message-ID: <52E6D579.7020303@suse.cz>
Date: Mon, 27 Jan 2014 22:54:01 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 03/11] bin2c: Move bin2c in scripts/basic
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-4-git-send-email-vgoyal@redhat.com> <52E6CBAA.1080405@suse.cz> <20140127211845.GD22256@redhat.com>
In-Reply-To: <20140127211845.GD22256@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.1.2014 22:18, Vivek Goyal napsal(a):
> On Mon, Jan 27, 2014 at 10:12:10PM +0100, Michal Marek wrote:
>> Dne 27.1.2014 19:57, Vivek Goyal napsal(a):
>>> Kexec wants to use bin2c and it wants to use it really early in the build
>>> process. See arch/x86/purgatory/ code in later patches.
>>>
>>> So move bin2c in scripts/basic so that it can be built very early and
>>> be usable by arch/x86/purgatory/
>>>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>> ---
>> [...]
>>> diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
>>> index 4fcef87..afbc1cd 100644
>>> --- a/scripts/basic/Makefile
>>> +++ b/scripts/basic/Makefile
>>> @@ -9,6 +9,7 @@
>>>  # fixdep: 	 Used to generate dependency information during build process
>>>  
>>>  hostprogs-y	:= fixdep
>>> +hostprogs-$(CONFIG_IKCONFIG)     += bin2c
>>
>> Is the CONFIG_IKCONFIG dependency still correct, now that you found
>> another use of bin2c?
> 
> In the next patch I changed depedency too. (CONFIG_BUILD_BIN2C). And
> now CONFIG_IKCONFIG and CONFIG_KEXEC will select CONFIG_BUILD_BIN2C.

OK, then it's all fine. I only saw patch 03/11.

Thanks,
Michal
