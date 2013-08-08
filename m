Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3HHNqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:46:10 -0400
Received: from crispin.apple.com ([17.151.62.50]:63635 "EHLO
	mail-out.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab3HHNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:46:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-AuditID: 11807158-b7f326d000001696-4a-5203a11adb48
Subject: Re: [edk2] Corrupted EFI region
From: Andrew Fish <afish@apple.com>
In-reply-to: <20130808101730.GJ2515@console-pimps.org>
Date: Thu, 08 Aug 2013 06:46:02 -0700
Cc: edk2-devel@lists.sourceforge.net, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>
Message-id: <1AEC7AA8-D49E-485F-A634-31B4F0D07083@apple.com>
References: <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
To: Matt Fleming <matt@console-pimps.org>
X-Mailer: Apple Mail (2.1508)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsUiOFOeU1dqIXOQwYQlOhbL7z5ms/i9upfN
	YuLKycwWf//8Z7ZYdaCD1WLZsR0sFm0PbzFaXN41h83i29VpTBZXH85mceDymNXQy+ZxpvEN
	o8fmFVoei/e8ZPLYveAzk8f7fVfZPNbd+Mru8XmTXABHFJdNSmpOZllqkb5dAlfGuyd9LAXP
	RSpuXOlibWA8KNDFyMkhIWAi8at5HSOELSZx4d56ti5GLg4hgU4mib7DB5hBEswCWhI3/r1k
	ArF5BfQklv6bA9YgLKAhsejON7AaNgFliRXzP7CD2JwCZhK7L39gA7FZBFQk7q3tY4GYc49J
	4sSaAghbW2LZwtfMEDNtJDouL2WHWDyfWaJ16kawZSICmhJzZi9j7WLkALpOVmLn76QJjPyz
	kJw0C8lJs5CMXcDIvIpRoCg1J7HSVC+xoCAnVS85P3cTIyj4GwojdjD+X2Z1iFGAg1GJh/dB
	EFOQEGtiWXFl7iFGCQ5mJRHeF1nMQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5IzcAVQukJ5ak
	ZqemFqQWwWSZODilGhj5pq4z8Vmd5e5wyPbZi3rLN4IuggEv2B5s3HmQu/d86oYvodon1TNz
	L9dev37ew2XNrPg+Pdf4vAtC95wnf5rdYMPd8G6VhH1u0Ts+M13rZP7Pq07d2z5bUbl423pN
	sSzm9WVWZv9tzwrP+vx43dnDpbr8Cjv+3uVxOiy939ZlqvL/CruqmoNKLMUZiYZazEXFiQCr
	R50FegIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8, 2013, at 3:17 AM, Matt Fleming <matt@console-pimps.org> wrote:

> On Wed, 07 Aug, at 02:10:28PM, Andrew Fish wrote:
>> Well the issue I see is I don't think OS X or Windows are doing this.
>> So I'm guessing there is some unique thing beings done on the Linux
>> side and we don't have good tests to catch bugs in the EFI
>> implementations. If the Linux loader hides the bugs and we don't hit
>> them with other operating systems they are never going to get fixed.
>> It would be good if we could track down some of these issues and make
>> a request for some tests that can help catch these issues. The tests
>> would be part of UEFI.org, but since some of us play in both worlds we
>> can forward the known issues to the UEFI test work group. 
> 
> I'm all for helping to develop tests that catch these kind of bugs.
> What's the next step?
> 

I'll bring this up with UEFI.org.

>> Is it possible to have a switch to turn off the not required behavior
>> (hiding EFI implementation bugs) so that bad platforms could be
>> detected? This would be a good thing to try on platforms at the
>> upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI
>> Forum, so the bad behavior can be detected and the vendors can fix the
>> issue. 
> 
> We don't tend to provide switches for the kernel to turn off workarounds
> because users run the risk of inadvertently stopping their machines from
> booting correctly. Also, because the major distributions will always
> enable the workarounds, the kernel would need to be built manually to
> see any kind of informative error message.
> 
> What we do have though is the Firmware Testsuite - fwts,
> 
>  https://wiki.ubuntu.com/Kernel/Reference/fwts
> 
> I know that Brian (Cc'd) has been doing some excellent advocacy work,
> getting people at plugfetsts to run this testsuite which tests for
> implementation bugs from within a Linux environment.
> 
>> PS Also maybe it would be possible to key this work around behavior on
>> the EFI/UEFI version. So for example no work-around after UEFI v2.3.1?
> 
> That would really depend on who has seen this bug and on which
> platforms. Is there a particular reason that mapping the boot services
> regions as-is would cause problems?
> 

1) The firmware bug could also be a security hole and thus needs to get fixed. 
2) The kernel gets locked into a design that does not follow the specification, and this limits future design options.
3) Makes the code more complex to maintain and test. 

> -- 
> Matt Fleming, Intel Open Source Technology Center

