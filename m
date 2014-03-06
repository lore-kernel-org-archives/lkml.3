Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaCFIUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:20:34 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:58800 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCFIUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:20:33 -0500
MIME-Version: 1.0
In-Reply-To: <1394037524.5094.35.camel@deneb.redhat.com>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
	<1393963738-9210-6-git-send-email-msalter@redhat.com>
	<CAL_JsqLQ8gj4nkwh+67i58rQBARoh_CgZ+4D9uepdBQm-XBwJA@mail.gmail.com>
	<1394037524.5094.35.camel@deneb.redhat.com>
Date: Thu, 6 Mar 2014 02:20:32 -0600
Message-ID: <CAL_JsqLSTMp4_OREGdGtah31HZmmMAgqi3eb3NZgM04dfqZNMQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] arm64: add early_ioremap support
From: Rob Herring <robherring2@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linaro Patches <patches@linaro.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 10:38 AM, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2014-03-04 at 17:31 -0600, Rob Herring wrote:
>> On Tue, Mar 4, 2014 at 2:08 PM, Mark Salter <msalter@redhat.com> wrote:
>> > Add support for early IO or memory mappings which are needed
>> > before the normal ioremap() is usable. This also adds fixmap
>> > support for permanent fixed mappings such as that used by the
>> > earlyprintk device register region.
>>
>> One minor comment:
>>
>> > +enum fixed_addresses {
>> > +       FIX_EARLYCON,
>>
>> Can you align this name with x86 and rename to FIX_EARLYCON_MEM_BASE.
>> Doing that will help enable the earlycon driver in 8250_early.c.
>
> Is there any advantage to earlycon=uart8250 vs. earlyprintk=uart8250?

Functionally, they are pretty much the same. I'm working on a series
to generalize earlycon and then we will be able to delete
early_printk.c from arm64 and ultimately share with arm. Doing this
alignment just saves a patch to change it later.

> I don't mind using FIX_EARLYCON_MEM_BASE, but CONFIG_FIX_EARLYCON_MEM
> is X86 only right now and I think changing that should be a separate
> patch.

Yes, definitely.

Rob
