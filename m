Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaDHQyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:54:25 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37767 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaDHQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <4778371.oH3kIlbD0f@wuerfel>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
 <20140408095038.GT17163@e106497-lin.cambridge.arm.com> <4778371.oH3kIlbD0f@wuerfel>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Apr 2014 10:54:01 -0600
Message-ID: <CAErSpo4RtEovyRXw=UXxBSz_hD4kfayBOkaKH_4Qk_s+hsEAxg@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 4:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 08 April 2014 10:50:39 Liviu Dudau wrote:
>> On Mon, Apr 07, 2014 at 06:58:24PM +0100, Bjorn Helgaas wrote:
>> > On Mon, Apr 7, 2014 at 5:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >
>> > > I think migrating other architectures to use the same code should be
>> > > a separate effort from adding a generic implementation that can be
>> > > used by arm64. It's probably a good idea to have patches to convert
>> > > arm32 and/or microblaze.
>> >
>> > Let me reiterate that I am 100% in favor of replacing arch-specific
>> > code with more generic implementations.
>> >
>> > However, I am not 100% in favor of doing it as separate efforts
>> > (although maybe I could be convinced).  The reasons I hesitate are
>> > that (1) if only one architecture uses a new "generic" implementation,
>> > we really don't know whether it is generic enough, (2) until I see the
>> > patches to convert other architectures, I have to assume that I'm the
>> > one who will write them, and (3) as soon as we add the code to
>> > drivers/pci, it becomes partly my headache to maintain it, even if
>> > only one arch benefits from it.
>
> Fair enough.
>
> My approach to the asm-generic infrastruction has mostly been to ensure
> that whoever adds a new architecture has to make things easier for the
> next person.

That's a good rule.  But if we add a generic implementation used only
by one architecture, the overall complexity has increased (we added
new unshared code), so the next person has to look at N+1 existing
implementations.  If we even convert one existing arch, that seems
like an improvement: we have N implementations with one being used by
at least two arches.

Bjorn
