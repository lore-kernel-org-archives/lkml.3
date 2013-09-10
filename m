Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3IJSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:55:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49435 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3IJSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130910185149.GC5559@kroah.com>
References: <1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	<1378774394.17982.36.camel@x230.lan>
	<alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	<1378781715.17982.42.camel@x230.lan>
	<alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	<1378785208.17982.54.camel@x230.lan>
	<20130910172318.GB21530@khazad-dum.debian.net>
	<1378837571.17615.0.camel@x230.lan>
	<522F6519.4030004@zytor.com>
	<20130910185149.GC5559@kroah.com>
Date: Tue, 10 Sep 2013 11:55:49 -0700
X-Google-Sender-Auth: qg9tl8qwiYiZ1AZySUt9gZoZsAQ
Message-ID: <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Kees Cook <keescook@chromium.org>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:51 AM, gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
> On Tue, Sep 10, 2013 at 11:29:45AM -0700, H. Peter Anvin wrote:
>> On 09/10/2013 11:26 AM, Matthew Garrett wrote:
>> > On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
>> >> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>> >>> That's why modern systems require signed firmware updates.
>> >>
>> >> Linux doesn't.  Is someone working on adding signature support to the
>> >> runtime firmware loader?
>> >
>> > It'd be simple to do so, but so far the model appears to be that devices
>> > that expect signed firmware enforce that themselves.
>> >
>>
>> Most devices do absolutely no verification on the firmware, and simply
>> trust the driver.
>>
>> So signing firmware is probably critical.
>
> How are you going to "validate" that the firmware is correct, given
> that it's just a "blob" living in the linux-firmware tree.  If you sign
> it, what is that saying?

In theory these blobs are traceable to a manufacturer. It's not really
an indication that it's "safe" more than it's an indication that it
hasn't been changed. But I haven't chased this very hard yet because
of below...

> I'm with Matthew here, any device that needs/wants this, has their own
> built-in checking, nothing the kernel should do here.
>
> Especially given that no other os does this :)

Yeah, it's impossible to handle since the way components do firmware
updates is frequently exposed to userspace anyway. 3G modems that do
firmware updates over the AT-command set, harddrives doing firmware
updates over SCSI-generic commands, etc. Creating this barrier in the
kernel is not a good solution; the component makers need to be doing
the enforcement. :(

-Kees

-- 
Kees Cook
Chrome OS Security
