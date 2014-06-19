Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbaFSQlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:41:24 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48616 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480AbaFSQlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1406191059520.1247-100000@iolanthe.rowland.org>
References: <CADDKRnDMbBzgkbC1tftGggfgsznntbO_st2fQW42d++D1rJsSw@mail.gmail.com>
	<Pine.LNX.4.44L0.1406191059520.1247-100000@iolanthe.rowland.org>
Date: Thu, 19 Jun 2014 18:41:17 +0200
Message-ID: <CADDKRnAm1FFhqB9PkWDcyY2DC-0WrVc_mfwCxKc51CZ+Z_ZJVQ@mail.gmail.com>
Subject: Re: [usb resume regression] in 3.16-rc1
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how to do this.

Thanks, Jörg

2014-06-19 17:02 GMT+02:00 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 19 Jun 2014, Jörg Otte wrote:
>
>> on resume with 3.16-rc1 I get the following error messages in dmesg
>> which are alltogether not present in 3.15:
>>
>> [   43.518116] dpm_run_callback(): 0xffffffffa53c4120 returns -13
>> [   43.518119] PM: Device 1-1 failed to resume async: error -13
>> [   43.522380] hub 1-1:1.0: hub_port_status failed (err = -71)
>> [   43.528538] sd 0:0:0:0: [sda] Starting disk
>> [   43.530886] hub 1-1:1.0: hub_port_status failed (err = -71)
>> [   43.535140] usb 1-1-port2: cannot disable (err = -71)
>> [   43.535142] dpm_run_callback(): 0xffffffffa53c4120 returns -71
>> [   43.535145] PM: Device 1-1.2 failed to resume async: error -71
>> [   43.543673] usb 1-1-port4: cannot disable (err = -71)
>> [   43.543674] dpm_run_callback(): 0xffffffffa53c4120 returns -71
>> [   43.543679] PM: Device 1-1.4 failed to resume async: error -71
>>
>> usb devices connected to the hub (in my case mouse and keyboard) are
>> all death after resume and cannot be activated again.
>
> -13 is -EACCES.  It's not clear what could have caused that error,
> since EACCES isn't used in the USB core or in ehci-hcd.
>
> Can you try doing the same thing after enabling dynamic debugging in
> usbcore and ehci-hcd?
>
> Alan Stern
>
