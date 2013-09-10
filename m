Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3IJSsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:48:10 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38063 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IJSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <1378837571.17615.0.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	<1378774394.17982.36.camel@x230.lan>
	<alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	<1378781715.17982.42.camel@x230.lan>
	<alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	<1378785208.17982.54.camel@x230.lan>
	<20130910172318.GB21530@khazad-dum.debian.net>
	<1378837571.17615.0.camel@x230.lan>
Date: Tue, 10 Sep 2013 11:48:06 -0700
X-Google-Sender-Auth: HQybcWlDl1K9yi_EYFk_X-5y1S0
Message-ID: <CAGXu5jKKG3tpNWJkLkQbGThku6Lpg8ZPuCaXCZ4F76gk14W-Ow@mail.gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:26 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>> > That's why modern systems require signed firmware updates.
>>
>> Linux doesn't.  Is someone working on adding signature support to the
>> runtime firmware loader?

I feel like there was maybe confusion here between "boot loader"
firmware (PC-BIOS, UEFI, etc), and device (maybe "component" is a
better term to distinguish this?) firmware (network cards, hard
drives, etc). Boot loader firmware has been moving rapidly toward
verified updates. This is true in many many shipping systems. It is
much less true for component firmware.

> It'd be simple to do so, but so far the model appears to be that devices
> that expect signed firmware enforce that themselves.

Yeah, the unfortunately reality is that for full sanity, it is
components themselves that need to be doing this signature validation.
That said, adding signature (or similar "origin" verification) to the
kernel is a good first step to move the trust from uid-0 up to ring-0.
I've had this on my TODO list for a while now. It remains a potential
hole, but since a solution doesn't exist today, it's outside of what
Matthew's patch series does. I would, however, expect that in the
future when component firmware loading includes origin verification,
it would become required when running with the "lock down the world"
setting.

-Kees

-- 
Kees Cook
Chrome OS Security
