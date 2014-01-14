Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaANPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:25:27 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56044 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:25:24 -0500
MIME-Version: 1.0
In-Reply-To: <201401141426.16497.arnd@arndb.de>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
	<201401140752.33257.arnd@arndb.de>
	<20140114114419.GH30907@bivouac.eciton.net>
	<201401141426.16497.arnd@arndb.de>
Date: Tue, 14 Jan 2014 15:25:23 +0000
Message-ID: <CAF7UmSwGgQ9u505s3fhd5MmGLHHy1A=rJLZBshycKr+rTniH1A@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Roy Franz <roy.franz@linaro.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2014 13:26, Arnd Bergmann <arnd@arndb.de> wrote:
>> > > Are you suggesting that I should #ifndef ARM in common code, or that I
>> > > should neglect to document what the common code will do with data it is
>> > > given by UEFI?
>> >
>> > It would probably be good to document the fact that it won't work,
>> > possibly even having a BUG_ON statement in the code for this case.
>>
>> Why?
>>
>> You'll only touch that pointer if you enable CONFIG_ACPI, and if you
>> do you probably want that address. Sounds a bit hostile to throw a BUG
>> in the face of someone who's (for example) just succeeded to get Linux
>> running on a Windows RT device.
>
> But we know that it can't work unless a lot of other things get changed
> in the kernel.

We know using ACPI cannot work without updates to the kernel.
That doesn't mean we need to throw a BUG just because the
firmware tells us a table exists.

>> Although no other architectures supported by UEFI support big-endian,
>> so to be honest, I don't want to have to be the first one to validate
>> that in order to get the basic support into the kernel.
>
> I think there was a project to run UEFI on PowerPC on some stage, though
> I can't find any code now.

That does sound familiar, but there is nothing in the specification.

/
    Leif
