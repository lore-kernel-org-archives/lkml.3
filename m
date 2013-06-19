Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab3FSJDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:03:09 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55688 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833Ab3FSJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:03:05 -0400
Message-ID: <51C173C2.3030402@message-id.googlemail.com>
Date: Wed, 19 Jun 2013 11:02:58 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Winkler, Tomas" <tomas.winkler@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
References: <51ACD4B2.7070107@message-id.googlemail.com> <51ACD600.2020805@message-id.googlemail.com> <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com> <51C0A684.8030405@message-id.googlemail.com> <5B8DA87D05A7694D9FA63FD143655C1B028D67D0@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B028D67D0@HASMSX106.ger.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

Am 19.06.2013 10:52, schrieb Winkler, Tomas:

>> So it is not yet fixed, unfortunately.
> 
> Not sure I understand how to reproduce it.  it is still falling on suspend/resume or just unbind/bind?
> Would you be so kind and send me the whole log.

Both is still broken. I'm actually not really sure if the unbind / bind
stuff is really related to the suspend / resume failure. The messages
just looked similar to me, but that might not mean anything.

Sending the whole log is not easy, since it overflows the dmesg buffer
(I have CONFIG_LOG_BUF_SHIFT=18 which is "big enough" usually) and the
journald just exits and restarts itself under such flooding, but I'll try.

Since the resume from suspend to RAM hangs, it is hard to get any logs
-- I never got the mei serial working before and a "real" serial port is
not present on this Thinkpad -- since the resume does not seem to
restart userspace before killing the machine, so nothing gets into the logs.

The suspend/resume failure is easily reproduced by

* booting with "init=/bin/bash no_console_suspend"
* mount /sys
* echo mem > /sys/power/state
* resume => lots of messages, finally kernel panic.

For the bind/unbind: the driver is built in (this is the openSUSE
kernel-of-the-day), but unbinding / rebinding also reproducibly floods
the logs. It does not seem to have additional side effects, but I cannot
test if mei actually still works afterwards.

I could try to take a picture of the panic, but it looked not really
directly related, more like a stack overflow after too many errors or
something like that (it also takes a few seconds after resume for the
machine to panic).

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
