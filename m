Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbbAOOJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:09:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:37079 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbbAOOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:09:50 -0500
Message-ID: <54B7CA15.7000200@roeck-us.net>
Date: Thu, 15 Jan 2015 06:09:25 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 12 (build failures: m68k, ppc)
References: <20150112180322.003b44f2@canb.auug.org.au>	<20150112162438.GA18723@roeck-us.net>	<CAMuHMdUYEe=L=H75AOYVjinRSW=okRJNrNJVy-bY1gshdVrO7Q@mail.gmail.com>	<20150112175920.GC19868@roeck-us.net> <CAMuHMdV1k4viMKmi_8vM52iz+ry50k=Ard1ADkEGzia+yJ5e3Q@mail.gmail.com>
In-Reply-To: <CAMuHMdV1k4viMKmi_8vM52iz+ry50k=Ard1ADkEGzia+yJ5e3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54B7CA2E.015C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:12 AM, Geert Uytterhoeven wrote:
> On Mon, Jan 12, 2015 at 6:59 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> Build failures, seen since next-20150109:
>>>>          m68k:allmodconfig
>>>>          powerpc:ppc6xx_defconfig
>
> It looks like parisc is also suffering:
> http://kisskb.ellerman.id.au/kisskb/buildresult/12343847/
>
>>>> Due to:
>>>>          ERROR: "__get_user_bad" [drivers/gpu/drm/drm.ko] undefined!
>>>>          make[1]: *** [__modpost] Error 1
>>>>
>>>> Caused by commit d34f20d6e2f (drm: Atomic modeset ioctl).
>>>
>>> Yeah, it needs a get_user() that supports 64-bit data.
>>>
>> Hi Geert,
>>
>> I assume you mean m68k, where 64 bit support for get_user has been disabled.
>>
>> The problem on powerpc is different though: __get_user_nocheck()
>> and __get_user_check() use
>>          unsigned long __gu_val;
>> followed by
>>          __get_user_size(__gu_val, __gu_addr, (size), __gu_err);
>>
>> __get_user_size() fails in
>>          if (size > sizeof(x))
>>                   (x) = __get_user_bad();
>>
>> Presumably "unsigned long" is 32 bit on 32 bit powerpc, not 64 bit.
>>
>> Overall, the explicit 64-bit use of get_user() seems to be quite unusual.
>
> I noticed you've sent a fix for DRM.
>
> Doh, and I was just fixing m68k...
>

Sorry, should have Cc:'d you.

Guenter

