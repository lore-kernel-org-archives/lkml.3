Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaKAMD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 08:03:27 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42520 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaKAMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 08:03:25 -0400
Message-ID: <5454CC07.1070605@gmail.com>
Date: Sat, 01 Nov 2014 15:03:19 +0300
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, Jonathan Corbet <corbet@lwn.net>
CC: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        "afaerber@suse.de" <afaerber@suse.de>
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
References: <1414454639-7491-1-git-send-email-agraf@suse.de> <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com> <20141028084735.6338d01b@lwn.net> <CF6E40FB-3CB1-43BD-8691-46AD21DA62A0@suse.de>
In-Reply-To: <CF6E40FB-3CB1-43BD-8691-46AD21DA62A0@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.10.2014 16:12, Alexander Graf пишет:
> 
> 
> 
>> Am 28.10.2014 um 13:47 schrieb Jonathan Corbet <corbet@lwn.net>:
>>
>> On Mon, 27 Oct 2014 20:07:51 -0400
>> Peter Foley <pefoley2@pefoley.com> wrote:
>>
>>>> The prctl test code in Documentation/ tries to show how to
>>>> use a call that only makes sense on x86. Restrict it there
>>>> so that other platforms don't try to call asm("rdtsc").
>>>>
>>>> Signed-off-by: Alexander Graf <agraf@suse.de>  
>>>
>>> Acked-by: Peter Foley <pefoley2@pefoley.com>
>>
>> Snagged into the docs tree, thanks.
> 
> Awesome, please make sure this makes it into 3.18 - the build is broken on non-x86 archs there ;).
> 
> Alex
> 

Hi,

Sorry for criticism, but the patch is not complete.
CONFIG_X86 deals with target architecture, at the same time the problem
deals with the host architecture.

Imagine, that I run arm, aarch64 or something else and do
cross-compiling kernel for x86 on it. Then CONFIG_X86 will evaluate to
'y' and make will try to compile the apps with the host-compiler, which
is not x86 one.


