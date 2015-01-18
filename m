Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbbARAuC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:50:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbbARAuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:50:00 -0500
Message-ID: <54BB031A.6050005@redhat.com>
Date: Sat, 17 Jan 2015 19:49:30 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: SMBIOS/DMI data under CONFIG_STRICT_DEVMEM
References: <54BAC21D.9040009@redhat.com> <20150117232142.GN3827@bivouac.eciton.net>
In-Reply-To: <20150117232142.GN3827@bivouac.eciton.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 06:21 PM, Leif Lindholm wrote:
> On Sat, Jan 17, 2015 at 03:12:13PM -0500, Jon Masters wrote:
>> Hi Catalin, all,
>>
>> I would like to ensure that the SMBIOS data provided by firmware is
>> always readable from userspace on AArch64, through /dev/mem.
> 
> No, we need to ensure /dev/mem can be completely disabled on any
> system that ever wants to have any level of reliability.

I think that's a wonderful goal! And so is world peace. It's even
slightly more achievable than world peace, but in the interim people are
going to want to be able to access memory through /dev/mem. However, in
the short term, if the below patches dmidecode for me, then I'll stop
whining about it and we'll wait for the next person ;)

> Fortunately, for SMBIOS there is /sys/firmware/dmi.

Indeed there is.

> Expect to see some
> patches from Ivan Khoronzhuk on this next week. (He has a working
> prototype of dmidecode, and a couple of minor kernel patches, as of
> yesterday.)

Great! I knew it was coming, I just hadn't heard when.

> For acpidump, there is /sys/firmware/acpi, and we're looking into that
> as well.

That one I'm not so worried about since I just copy the files and run
iasl -d, which I think is what most others do, and very few sysadmin
type tools need to do that directly. But things do call dmidecode.

>> When building a kernel with CONFIG_STRICT_DEVMEM, arm64 follows broadly
>> x86 with the exception of an assumption surrounding the low range of
>> memory (which doesn't apply on AArch64 platforms universally anyway).
>> Thus on x86, they can directly read the SMBIOS table from dmidecode when
>> it tries to map /dev/mem due to its location. I'm hacking something up
>> for the moment, but I would like to solve this.
> 
> STRICT_DEVMEM is a trainwreck on all architectures

Yep. It does seem to be particularly unpleasant.

> but particularly bad on ARM*, since we don't have anything resembling
> a predictable memory map.

In case anyone cares, I did make several formal proposals to standardize
the memory map rigorously on ARM servers precisely for this reason (I
even warned ahead of time about this situation, and that of the runtime
location of EFI, etc.), but hw vendors did not want that. I can but push
to make everything rigidly uniform and boring ;)

> While I like Ard's approach to improve it with data
> actually available, I would also like add the ability to make it
> tweakable as read-write, read-only or no access.

Cool.

> I sent out a series looking to consolidate STRICT_DEVMEM handling
> across architectures (i.e. not have separate definitions per
> architecture Kconfig), but had little response. If anyone is
> interested in seeing that happening, let me know and I'll resend with
> you on cc.

I would love to take a look.

Jon.

