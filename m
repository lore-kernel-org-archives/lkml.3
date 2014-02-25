Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaBYQOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:14:04 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40910 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBYQOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:14:02 -0500
MIME-Version: 1.0
In-Reply-To: <530CBB3D.3080604@zytor.com>
References: <20140224162400.GE16457@pd.tnic>
	<20140224201943.GA4397@pd.tnic>
	<530CBB3D.3080604@zytor.com>
Date: Tue, 25 Feb 2014 17:14:01 +0100
Message-ID: <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to understand your test case.
Were you actually measure uncore_imc events at the time you suspended?

I tried on my IvyBridge Lenovo and it works fine with 3.14-rc4+ (tip.git).
I used: echo -n disk >/sys/power/state




On Tue, Feb 25, 2014 at 4:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/24/2014 12:19 PM, Borislav Petkov wrote:
>> Btw,
>>
>> I don't know whether the following observation is related or not, but it
>> so happens that after resume from suspend-to-disk, I see the booting up
>> of the resume kernel on the console but when it is time for the original
>> kernel to take over and switch to graphics, the screen remains black but
>> the machine is responsive over the network.
>>
>> And this doesn't happen on every resume but only sporadically.
>>
>> And yep, -rc3 was fine.
>>
>> On Mon, Feb 24, 2014 at 05:24:00PM +0100, Borislav Petkov wrote:
>>> This started happening this morning after booting -rc4+tip, let's
>>> add *everybody* to CC :-)
>>>
>>> We have intel_uncore_init, snb_uncore_imc_init_box, uncore_pci_probe and
>>> other goodies on the stack.
>>>
>
> snb_uncore_imc_init_box() is introduced new in tip:perf/core, and is a
> relatively recent commit (b9e1ab6d4c0582cad97699285a6b3cf992251b00), so
> I suspect that that wasn't in whatever -rc3 mix you were testing.
>
> I am wondering if backing/disabling out that support (perhaps by
> removing the relevant PCI ID) fixes the problem?
>
>         -hpa
>
