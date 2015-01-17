Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAQVBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 16:01:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbbAQVBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 16:01:48 -0500
Message-ID: <54BACD9D.3080505@redhat.com>
Date: Sat, 17 Jan 2015 16:01:17 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: SMBIOS/DMI data under CONFIG_STRICT_DEVMEM
References: <54BAC21D.9040009@redhat.com> <CAKv+Gu_kZ+b8CBbiWLW3KW5Nw7qewpN7+N6a910dFaiRcs1xKQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_kZ+b8CBbiWLW3KW5Nw7qewpN7+N6a910dFaiRcs1xKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 03:59 PM, Ard Biesheuvel wrote:
> On 17 January 2015 at 20:12, Jon Masters <jcm@redhat.com> wrote:
>> Hi Catalin, all,
>>
>> I would like to ensure that the SMBIOS data provided by firmware is
>> always readable from userspace on AArch64, through /dev/mem.
>>
> 
> This has been on our radar for a while
> 
>> When building a kernel with CONFIG_STRICT_DEVMEM, arm64 follows broadly
>> x86 with the exception of an assumption surrounding the low range of
>> memory (which doesn't apply on AArch64 platforms universally anyway).
>> Thus on x86, they can directly read the SMBIOS table from dmidecode when
>> it tries to map /dev/mem due to its location. I'm hacking something up
>> for the moment, but I would like to solve this.
>>
> 
> Check out my series here
> http://article.gmane.org/gmane.linux.kernel.efi/5133
> 
> The general idea is to remove all UEFI runtime regions (including
> config tables) from the linear mapping, and allow r/o access via
> /dev/mem to such regions, using a mapping type which can support
> unaligned access (which is required for SMBIOS). As for the iomem
> resources, we need to reserve the regions we know are in use,
> regardless of how that affects the existing logic around
> devmem_is_allowed (and I am sure we can do better than what
> page_is_ram currently does, which is matching the string 'System RAM'
> against the iomem resource table)

Ah. So you have it in hand. Great. We'll go with a temporary workaround
and wait for your series for the fix. Will take a look and review.

Jon.


