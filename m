Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBWDop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 22:44:45 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40301 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBWDoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 22:44:44 -0500
MIME-Version: 1.0
In-Reply-To: <201402222242.45552.gheskett@wdtv.com>
References: <201402222022.20370.gheskett@wdtv.com>
	<CAKb7UvjertO2FEPL+5_wKhrFVfYA5_dBe70EoyY9fZ881CY-GQ@mail.gmail.com>
	<201402222242.45552.gheskett@wdtv.com>
Date: Sat, 22 Feb 2014 22:44:43 -0500
X-Google-Sender-Auth: 8u3cTjQ_tCLqyrY5C7hDIR88ydA
Message-ID: <CAKb7Uvhj3S88VOeprPsOQpzrCzOn3nB5CeDtDUhCxabLuPuPCA@mail.gmail.com>
Subject: Re: It BOOTS! 3.13.5 that is.
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Gene Heskett <gheskett@wdtv.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:42 PM, Gene Heskett <gheskett@wdtv.com> wrote:
> On Saturday 22 February 2014, Ilia Mirkin wrote:
>>On Sat, Feb 22, 2014 at 8:22 PM, Gene Heskett <gheskett@wdtv.com> wrote:
>>> But my tv card isn't being found by kaffeine.  It is this card:
>>>
>>> 01:08.0 Multimedia video controller: Conexant Systems, Inc.
>>> CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
>>>
>>>         Subsystem: pcHDTV Device 3000
>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>>>         Capabilities: [44] Vital Product Data <?>
>>>         Capabilities: [4c] Power Management version 2
>>>
>>> 01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
>>> Video and Audio Decoder [MPEG Port] (rev 05)
>>>
>>>         Subsystem: pcHDTV Device 3000
>>>         Flags: bus master, medium devsel, latency 32, IRQ 10
>>>         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>>>         Capabilities: [4c] Power Management version 2
>>>
>>> From an lspci
>>>
>>> In a make xconfig, I cannot find this specific card in the list of DVB
>>> front ends.  What modules do I need to make sure are being built?
>>
>>You're looking for VIDEO_CX88 ("Conexant 2388x (bt878 successor)
>>support") and its various sub-options (esp CX88_DVB). iirc the
>>pchdtv3000 had a OR51132 tuner, but right now the config is set to
>>auto-select a whole bunch of tuners if you have
>>MEDIA_SUBDRV_AUTOSELECT turned on. Otherwise make sure to select that
>>tuner device. (Hm, I appear to have both OR51132 and CX22702 enabled,
>>and I have that same card.)
>>
>>  -ilia
> or51132 rings a bell and is enabled, CX22702 is not.  And I don't seem to
> be able to find the CX88** at all.  I'll give the CX22702 a shot, thanks a
> bunch ilia.

grep CX88 .config

If it says "not set" for things like CONFIG_VIDEO_CX88_DVB, you won't
get anything to work.

  -ilia
