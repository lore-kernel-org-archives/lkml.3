Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaBVNka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 08:40:30 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48361 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749AbaBVNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 08:40:28 -0500
Message-ID: <5308A8C8.8030000@hurleysoftware.com>
Date: Sat, 22 Feb 2014 08:40:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, Hannes Reinecke <hare@suse.de>
CC: Ray Strode <halfline@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
References: <20140220235118.191692546@linuxfoundation.org>	<20140220235119.236520201@linuxfoundation.org>	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>	<5307683C.50209@suse.de>	<CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>	<CAPXgP12Vs3LtVPOxF-Tnn4H7NjD6unXtPEOjFzRRhJhf0xndRQ@mail.gmail.com>	<CAA_UwzK38FpDgv0RKfQG_QZd-OttZBQC60UffbyUGWq8E05PpQ@mail.gmail.com> <CANq1E4T25a3JkYB_JggtueygqpGVn0vBmaMZXvohWb_jinxuag@mail.gmail.com>
In-Reply-To: <CANq1E4T25a3JkYB_JggtueygqpGVn0vBmaMZXvohWb_jinxuag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 08:25 AM, David Herrmann wrote:
> Hi
>
> On Fri, Feb 21, 2014 at 11:53 PM, Ray Strode <halfline@gmail.com> wrote:
>> Hi,
>>
>> On Fri, Feb 21, 2014 at 11:01 AM, Kay Sievers <kay@vrfy.org> wrote:
>>> Why did the tty0 change to tty1 now? That doesn't look like a "driver
>>> name" vs. "device name" issue?
>>
>> I don't know if it's intentional, but the patch does:
>> +               int index = cs[i]->index;
>> ...
>> +               driver = cs[i]->device(cs[i], &index);
>>
>> which will presumably change the index from 0 to 1 because of this code:
>>
>> static struct tty_driver *vt_console_device(struct console *c, int *index)
>> {
>>         *index = c->index ? c->index-1 : fg_console;
>>         return console_driver;
>> }
>>
>> At least that's what it looks like is causing the problem from
>> browsing through the source a bit.
>
> Yepp, that's it. So if you configure the console to always be
> redirected to the foreground terminal, you simply bind it to tty0 and
> this file used to return tty0 then.
> With this patch, we actually return the foreground terminal instead,
> so tty0 is resolved to the real VT. This sounds like the correct
> behavior (even though it currently breaks poll() on this file). But if
> it breaks stuff, we should revert it and add a second file just like
> Peter suggested.

Or add sysfs entries for each console that exposes the device, so
that the underlying device is trivially discoverable, which is the
original problem.

Regards,
Peter Hurley

