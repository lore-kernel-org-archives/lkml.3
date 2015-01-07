Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbbAGRqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:46:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbbAGRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:46:10 -0500
Message-ID: <54AD7098.5010700@redhat.com>
Date: Wed, 07 Jan 2015 12:44:56 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <2161376.07iV9ANMSk@wuerfel> <20150107115039.GA2199@e104818-lin.cambridge.arm.com> <1520439.Y1rXzXY1eS@wuerfel> <20150107172741.GY2634@sirena.org.uk>
In-Reply-To: <20150107172741.GY2634@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 12:27 PM, Mark Brown wrote:
> On Wed, Jan 07, 2015 at 02:06:28PM +0100, Arnd Bergmann wrote:
>> On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:
> 
>>> From what I gathered so far, the main reason for _some_ vendors is not
>>> support for "other" OS but actually features that ACPI has and DT
>>> doesn't (like AML; I deliberately ignore statements like "industry
>>> standard"). _If_ such reasons are sound, maybe they have a case for
>>> ACPI-only machines targeted primarily at Linux.
> 
>> What I got from the replies from HP, Huawei and from earlier discussions
>> with Jon is that they all hope to get to the point of relying on AML
>> alone to bridge the differences between SoC families.

I'm expecting to need new drivers for SoC IP blocks that are net new,
but generational differences between iterations of the same SoC should
be abstracted behind the firmware (and we are already seeing this with
at least one platform). Platform wise, it's nice to already see e.g.
mmconfig working to handle the specific ways a platform wires PCI.

> I tend to agree with you that it's an overreach to think that this is
> going to completely abstract away the differences between SoCs from
> different vendors without substantial further standardization work.

(which we plan to do - I intend ultimately for us to have an answer to
the Windows Hardware Qualification guides for ARM server systems)

> However it does seem reasonable to expect that features like AML are
> going to be more successful in handling board differences and
> incremental revisions of SoCs - things like interactions with system
> power controllers for example.  That seems like a useful win in and of
> itself, and one that's worth supporting.

Indeed.

>> The main problem here is that can AML only cover part of the problem:
>> it can talk to a clock controller e.g. over I2C, SPI, GPIO, UART
>> or IPMI, but you still need a device driver in the kernel to talk to
>> those, and SBSA doesn't mandate a specific implementation so you can
>> expect every other SoC that is coming out to have a different one.
> 
>> Similarly, SBSA is rather vague about some peripherals it mandates,
>> and if a new SoC has a slightly different AHCI variation, there is
>> nothing you can do about it in AML.
> 
>> x86 gets around this problem by having an extreme level of hardware
>> backwards compatibility, so you don't even need AML for this and
>> can generally boot a (almost) full-featured Linux kernel with
>> acpi=off on the command line.
> 
> That level of hardware compatibility does partly come from the need to
> run existing software.  I'd expect that similar effects will start to
> come into play with ARMv8 ACPI systems if they become successful; people
> will do things like ensure compatibility with common IPs that have
> existing Linux drivers that distros tend to include as standard.

Agreed.

Jon.

