Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaLVPs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:48:58 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:35497
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaLVPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:48:57 -0500
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=dY0O3Bne c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=DrNGYBpgUcYA:10 a=N659UExz7-8A:10
 a=a5Gf7U6LAAAA:8 a=D19gQVrFAAAA:8 a=qYJF-06cJdgzHjE1qMkA:9 a=pILNOxqGKmIA:10
Message-ID: <54983D66.6020506@blueyonder.co.uk>
Date: Mon, 22 Dec 2014 15:48:54 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mark Hounschell <markh@compro.net>, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org
Subject: Re: 3.19.0-rc1 nouvea build failure on GeForce GT 610 only
References: <54981647.8010409@blueyonder.co.uk>	 <1419255471.30945.47.camel@x220> <1419256493.30945.53.camel@x220>
In-Reply-To: <1419256493.30945.53.camel@x220>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 13:54, Paul Bolle wrote:
> On Mon, 2014-12-22 at 14:37 +0100, Paul Bolle wrote:
>> On Mon, 2014-12-22 at 13:01 +0000, Sid Boyce wrote:
>>>     CHK     kernel/config_data.h
>>>     CC [M]  drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o
>>> drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c: In function
>>> ‘nvd0_dmaobj_bind’:
>>> drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c:54:8: error:
>>> ‘GM204_DISP_CORE_CHANNEL_DMA’ undeclared (first use in this function)
>>>      case GM204_DISP_CORE_CHANNEL_DMA:
>>>           ^
>>> drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c:54:8: note: each
>>> undeclared identifier is reported only once for each function it appears in
>>> scripts/Makefile.build:257: recipe for target
>>> 'drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o' failed
>>> make[4]: *** [drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o] Error 1
>>> scripts/Makefile.build:402: recipe for target 'drivers/gpu/drm/nouveau'
>>> failed
>>> make[3]: *** [drivers/gpu/drm/nouveau] Error 2
>>> scripts/Makefile.build:402: recipe for target 'drivers/gpu/drm' failed
>>> make[2]: *** [drivers/gpu/drm] Error 2
>>> scripts/Makefile.build:402: recipe for target 'drivers/gpu' failed
>>> make[1]: *** [drivers/gpu] Error 2
>>> Makefile:938: recipe for target 'drivers' failed
>>> make: *** [drivers] Error 2
>>>
>>> 01:00.0 VGA compatible controller: NVIDIA Corporation GF119 [GeForce GT
>>> 610] (rev a1)
>> Why would that controller influence the build?
>>
>>> No problems on 2 other boxes with GeForce 8600 GT] (rev a1)
>> I ran into this error twice, while building Fedora 21 kernel rpms for
>> v3.19-rc1 on my outdated ThinkPad X41 (which uses i915, for what it's
>> worth). The error made very little sense to me. Especially since it
>> didn't happen when building in the local git repository.
>>
>> So I basically, well, scrubbed the rpmbuild environment. And then the
>> the third attempt to build kernels rpm succeeded! I assumed a hardware
>> failure (see outdated above) and made a mental note to investigate that
>> one of these days.
>>
>> But your report makes me think it's not my hardware. Could there be some
>> _random_ failure with this driver in the build? Very odd...
> A theory based on Mark's message in
> https://lkml.org/lkml/2014/12/8/602 :
>
> My two failed builds somehow used previous version of class.h, that
> didn't yet have commit 1f89b4756fb8 ("drm/gm204/disp: initial support")
> applied. It's that commit which added the define for
> GM204_DISP_CORE_CHANNEL_DMA.
>
> Is that even possible? Perhaps rpmbuild has a surprising way to handle
> symlinks? All very puzzling...
>
>
> Paul Bolle
>
>
I did a git pull up to 3.19-rc1 separately on the 3 boxes and used the 
.config from 3.18.0 as the base of make oldconfig.

When the build failed I did "make mrproper" and used the .config from 
one of the other boxes, then from the other, all 3 .config gave the same 
error.

Successfully rebooted one of the boxes.
sabre:~ # uname -r
3.19.0-rc1-smp+

Regards ... Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot Emeritus 
IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Senior Staff 
Specialist, Cricket Coach Microsoft Windows Free Zone - Linux used for 
all Computing Tasks
