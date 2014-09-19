Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbaISUdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:33:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbaISUdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:33:01 -0400
Message-ID: <541C92F9.1020805@suse.de>
Date: Fri, 19 Sep 2014 22:32:57 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Rivera Jose-B46482 <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>	<20140915184451.962a3a19c4940792d182f10a@freescale.com>	<541A5CF1.8000409@freescale.com>	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>	<20140918152233.41647ee517393816bb35b72a@freescale.com>	<541B9D5F.20008@freescale.com>	<20140919121912.197b15bd3b79fb90d7f97602@freescale.com>	<3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com> <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
In-Reply-To: <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19.09.14 22:24, Kim Phillips wrote:
> On Fri, 19 Sep 2014 14:06:32 -0500
> Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
> 
>>>>>>>>> +/**
>>>>>>>>> + * @brief    Management Complex firmware version information
>>>>>>>>> + */
>>>>>>>>> +#define MC_VER_MAJOR 2
>>>>>>>>> +#define MC_VER_MINOR 0
>>>>>>>>
>>>>>>>> code should be adjusted to run on all *compatible* versions of h/w,
>>>>>>>> not strictly the one set in these defines.
>>>>>>> This comment is not precise enough be actionable.
>>>>>>> What exactly you want to be changed  here?
>>>>>>
>>>>>> I think the easy thing to do is to convert the exact version check into a ranged version check: have
>>> minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
>>> version at all - or only for the major version and guarantee that the major version indicates backwards
>>> compatibility.
>>>>>
>>>>> yes, this was my point: elsewhere I noticed the code denies to run
>>>>> iff those defines are not matched exactly: that code should change
>>>>> to run as Alex describes.
>>>>>
>>>> As I mentioned in the reply to Alex, I will remove the minor version check.
>>>
>>> the code should be able to run on all subsequent versions of the
>>> h/w, even in the major version case.
>>
>> You're right, in the future if there are future major versions we would want this
>> same driver to function on multiple versions of the hardware.  But at this
>> point in time we don't know what future evolutions there will be and we 
>> need the check to error out for now.
> 
> why?  We have to make the standard assumption that newer versions
> will be backward compatible, in which case the driver should be left
> to run.

How much is the interface set in stone? Can we indicate to the MC that
we want version x of the protocol? Then the MC can tell us whether it's
compatible or not.

> 
>>   The driver will have to be changed
>> in the future to dynamically deal with different versions.
>>
>> We could add a TODO in the driver to note that.
> 
> "TODO: add support for new h/w versions" is almost universally true
> for all drivers, we don't need to write that down.
> 
> Support for new h/w versions with new features should be
> incrementally added once they're known.

The "version id" is basically the equivalent of the pci device id. We
don't add wildcards there either for unknown pieces of hardware, so
limiting to driver to "known good" devices is sane IMHO.


Alex
