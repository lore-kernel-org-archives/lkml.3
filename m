Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaIBXYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIBXYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:24:40 -0400
Message-ID: <540651B3.8030400@infradead.org>
Date: Tue, 02 Sep 2014 16:24:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com> <53FB9DA0.7000301@infradead.org> <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
In-Reply-To: <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 15:58, Peter Foley wrote:
> On Mon, Aug 25, 2014 at 4:33 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 04/17/14 07:11, Peter Foley wrote:
>> Hi Peter,
>>
>> Sorry about the delay and thanks for the patches.
>>
>> I have now applied all 4 of these patches, with a few small changes in
>> Documentation/laptops/ to account for hpfall.c being renamed to freefall.c
>> and the problems with it having already been fixed by other patches.
>>
>> [testing]
>>
>> Documentation/vDSO/* does not build for me:
>>
>>   HOSTCC  Documentation/vDSO/parse_vdso.o
>>   HOSTCC  Documentation/vDSO/vdso_test.o
>>   LD      Documentation/video4linux/built-in.o
>>   HOSTLD  Documentation/vDSO/vdso_test
>>   CC [M]  Documentation/video4linux/v4l2-pci-skeleton.o
>> /usr/lib64/gcc/x86_64-suse-linux/4.8/../../../../x86_64-suse-linux/bin/ld: warning: cannot find entry symbol _start; defaulting to 000000000040017c
>> Documentation/vDSO/parse_vdso.o: In function `vdso_match_version':
>> parse_vdso.c:(.text+0x48e): undefined reference to `strcmp'
>> Documentation/vDSO/parse_vdso.o: In function `vdso_sym':
>> parse_vdso.c:(.text+0x59c): undefined reference to `strcmp'
>> Documentation/vDSO/vdso_test.o: In function `main':
>> vdso_test.c:(.text+0x15): undefined reference to `getauxval'
>> vdso_test.c:(.text+0x2a): undefined reference to `puts'
>> vdso_test.c:(.text+0x3e): undefined reference to `getauxval'
>> vdso_test.c:(.text+0x6a): undefined reference to `puts'
>> vdso_test.c:(.text+0xa8): undefined reference to `printf'
>> vdso_test.c:(.text+0xb4): undefined reference to `puts'
>> collect2: error: ld returned 1 exit status
>> make[3]: *** [Documentation/vDSO/vdso_test] Error 1
>>
>> I have all of the others building and vDSO commented out for now.
>>
>> Any suggestions, ideas, or fixes?
>>
>>
>> Also, I haven't checked each source file individually, but I expect that
>> many of these are tools that could (should) be moved to $srctree/tools,
>> if you or anyone else is interested in that.
>>
>> Thanks,
>> --
>> ~Randy
> 
> So I finally found the time to look at the vDSO test and figure out
> what the issue was.
> However, the commits no longer seem to be in linux-next.
> Is there some other tree I should be looking at?

The regular linux-next maintainer is on vacation (or something).

It appears that the interim maintainer didn't import quilt patches for some reason.

I guess the quilt patches will be back whenever Stephen Rothwell is back.

Mark, do you have any ideas about this?

Importing jdelvare-hwmon based on 3.15-rc7
Unknown BASE
Importing rd-docs based on 3.17-rc1
Unknown BASE


Thanks,



-- 
~Randy
