Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3KTCOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:14:21 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:48698 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3KTCOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:14:18 -0500
MIME-Version: 1.0
In-Reply-To: <20131114180538.GK11022@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-3-git-send-email-bleung@chromium.org>
	<20131021065804.GX3521@intel.com>
	<CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
	<20131114180538.GK11022@katana>
Date: Tue, 19 Nov 2013 18:14:18 -0800
X-Google-Sender-Auth: v1ySDF9U6RIEFsKlpuwVrpYzrUI
Message-ID: <CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
From: Benson Leung <bleung@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Nov 14, 2013 at 10:05 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> In the chromeos_laptop driver, I do by-name matching of i2c busses to
>> find busses and instantiate devices, so there is value to have each
>> named something predictable.
>
> Any why don't you use fixed bus numbers which you can attach the devices
> to?

On this particular set of systems, there are two other classes of i2c
adapters that use dynamically assigned bus numbers, specifically the
i915 gmbus adapters, and the i801_smbus adapter. This is why
chromeos_laptop uses the name matching, as some of the boards that it
supports have devices on those dynamic busses.

I can't guarantee that these other busses will always have the same
bus numbers, nor can I guarantee that this driver
(i2c_designware_pcidrv) is loaded before or after the others, so it
seemed the right thing to do to to make sure that the names of each of
the adapters correspond to how they are referred to on various
schematics and datasheets.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
