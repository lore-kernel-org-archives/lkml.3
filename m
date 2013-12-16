Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3LPNBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:01:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3LPNBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:01:33 -0500
Message-ID: <52AEF997.906@redhat.com>
Date: Mon, 16 Dec 2013 08:01:11 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
References: <1385997579-22240-1-git-send-email-prarit@redhat.com> <1385997579-22240-2-git-send-email-prarit@redhat.com> <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org> <201312041922.59181.arnd@arndb.de> <20131205113016.GB3823@console-pimps.org> <1386258903.10003.8.camel@joe-AO722> <20131206123026.GB3597@console-pimps.org>
In-Reply-To: <20131206123026.GB3597@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry everyone, I was out on PTO for the past few weeks.


On 12/06/2013 07:30 AM, Matt Fleming wrote:
> On Thu, 05 Dec, at 07:55:03AM, Joe Perches wrote:
>> On Thu, 2013-12-05 at 11:30 +0000, Matt Fleming wrote:
>>> On Wed, 04 Dec, at 07:22:57PM, Arnd Bergmann wrote:
>>>> The other part I noticed about this particular patchset is that it's
>>>> not really "firmware" as such, but specifically PC wiht ACPI that
>>>> gets covered here. So rather than generalizing the code, another
>>>> option would be to narrow down the scope and make it
>>>> acpi_{warn,info,dbg} instead.
>>>
>>> Making this specific to ACPI runs the risk of people introducing a
>>> multitude of new logging functions for every subsystem, e.g.
>>> efi_{warn,info,dbg}.
>>
>> There are many subsystem specific logging functions:
> 
> Surely that's further justification to not introduce any more.

That's what I was thinking when I saw this discussion.

> 
>>> FWIW, I'd be interested in using something like this patch series to
>>> properly log EFI implementation bugs. The logging for EFI is currently
>>> done fairly haphazardly.
>>
>> I thought that was the point of embedding the existing
>> FW_INFO, FW_WARN and FW_BUG #defines in formats.
>>
>> Using logging message scraping to find faults is not
>> a great approach as message content is subject to change.
> 
> I wasn't planning on using them to scrape the kernel logs, just for more
> informative messages.

Exactly.  That's the whole point here -- the only mechanism that exists for
tracking firwmare related issues, like it or not, is the kernel log/dmesg/boot
log/whatever we're calling it these days.  It's been done this way since the
beginning of time.

The problem I'm trying to solve, and as Andrew commented on, is a *real*
problem.  The information we currently dump out is not useful to anyone.

Could this be expanded to other subsystems?  Yes, without question.  It's
actually the ACPI and PCI subsystems that I want to target next, however, both
of those will require a base change to FW_{INFO|WARN|BUG} to at least get us a
starting point.

P.

> 
