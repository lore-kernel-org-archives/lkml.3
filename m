Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902AbaIFFEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 01:04:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52653 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIFFEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 01:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140906024253.GB11389@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
	<1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
	<20140906024253.GB11389@vmdeb7>
Date: Fri, 5 Sep 2014 23:04:18 -0600
Message-ID: <CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

2014-09-05 20:42 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Fri, Sep 05, 2014 at 11:14:05AM -0600, Azael Avalos wrote:
>> The accelerometer sensor is very sensitive, and having userspace
>> poll the sysfs position entry is not very battery friendly.
>>
>> This patch removes the sysfs entry and instead, it creates an
>> input polled device (joystick) for the built-in accelerometer.
>
> Hrm, while sysfs details can change across kernel versions, usually due to
> driver core changes, we try to keep them as consistent as possible so as not to
> break userspace.
>
> That said, if we are going to try and come up with a better model for
> representing an accelerometer, wouldn't treating it as an IIO device be the more
> logical approach?

Yes of course, but the actual accelerometer device (sensor?) is not
really exposed,
only certain "functions" it provides, and they are divided across two
different ACPI devices,
TOS620A exposes the protection, and the TOS1900 (and et. al.) only
exposes the axes.

I see your point in breaking userspace, but given the fact that it was
recently introduced,
I didn't thought it was already "adopted", that's why I decided to
remove the sysfs entry.

Then we might as well keep the sysfs entry and have the input polled
device as well.

>
> --
> Darren Hart
> Intel Open Source Technology Center


Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
