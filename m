Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab3FCRoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:44:38 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56912 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCRog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:44:36 -0400
Message-ID: <51ACD600.2020805@message-id.googlemail.com>
Date: Mon, 03 Jun 2013 19:44:32 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
References: <51ACD4B2.7070107@message-id.googlemail.com>
In-Reply-To: <51ACD4B2.7070107@message-id.googlemail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.06.2013 19:38, schrieb Stefan Seyfried:
> Or, to be more precise: it breaks resume.
> 
> The machine seems to lock up hard after resume, then after a few seconds
> it panics (caps lock blinking).
> 
> Reproduced on ThinkPad X200s
> 
> 00:03.0 0780: 8086:2a44 (rev 07)
> Intel Corporation Mobile 4 Series Chipset MEI Controller
> 
> Debugged with "init=/bin/bash no_console_suspend", I see lots of errors
> from the mei_me driver, then finally the panic (some overflow maybe?).
> 
> Unbinding the device before suspend fixes resume.

I just noticed that I get the following message on unbinding:

$ echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/unbind
$ dmesg|tail -2
[ 1216.830034] mei_me 0000:00:03.0: stop
[ 1216.837018] mei_me 0000:00:03.0: wait hw ready failed. status = 0x0

not sure if this is related.

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
