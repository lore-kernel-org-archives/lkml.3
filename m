Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBKNDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:03:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBKNDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:03:06 -0500
MIME-Version: 1.0
In-Reply-To: <52E303FF.2010808@mit.edu>
References: <1390504562-20333-1-git-send-email-curt@cumulusnetworks.com>
	<52E303FF.2010808@mit.edu>
Date: Tue, 11 Feb 2014 13:03:05 +0000
X-Google-Sender-Auth: 20k6RsPzfpOKfT-jGzk_Lz6_9lo
Message-ID: <CAOMwXhMu5gW5cjTSW9qe-DNUA1isNNoghn=E5CgWoM4AcOw2TQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Create eeprom_dev hardware class for EEPROM devices
From: Laszlo Papp <lpapp@kde.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Curt Brune <curt@cumulusnetworks.com>, Wolfram Sang <wsa@the-dreams.de>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 12:23 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 01/23/2014 11:16 AM, Curt Brune wrote:
>> Create a new hardware class under /sys/class/eeprom_dev
>>
>> EEPROM drivers can register their devices with the eeprom_dev class
>> during instantiation.
>>
>> The registered devices show up as:
>>
>>   /sys/class/eeprom_dev/eeprom0
>>   /sys/class/eeprom_dev/eeprom1
>>   ...
>>   /sys/class/eeprom_dev/eeprom[N]
>>
>> Each member of the eeprom class exports a sysfs file called "label",
>> containing the label property from the corresponding device tree node.
>>
>> Example:
>>
>>   /sys/class/eeprom_dev/eeprom0/label
>>
>> If the device tree node property "label" does not exist the value
>> "unknown" is used.
>>
>> Note: The class cannot be called 'eeprom' as that is the name of the
>> I/O file created by the driver.  The class name appears as a
>> sub-directory within the main device directory.  Hence the class name
>> 'eeprom_dev'.
>>
>> Userspace can use the label to identify what the EEPROM is for.
>
> Since my previous email [1] seems to have vanished into the void, I'll
> try again more succinctly:
>
> How will this work on non device tree / openfirmware systems?
>
> Is there a better way to expose topology information (i.e. that the
> eeprom belongs to another device that might not live on the i2c bus at all)?
>
> Can we expose type information?  There's a big difference between SPD
> EEPROMs, EDID EEPROMs, and nic mac-address-containing EEPROMs, for example.

I personally do not see major issues for improving that, but it might
be just me.
