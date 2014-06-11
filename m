Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaFKVXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:23:07 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:54743 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaFKVXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:23:05 -0400
Date: Wed, 11 Jun 2014 23:23:02 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Benson Leung <bleung@chromium.org>
cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] platform/chrome: Probe multiple i2c adapters of
 the same name
In-Reply-To: <CANLzEkuGWd9s1Ka32BrgGxrCF+gGqVA4=uKuGJMerWaz6NDMpA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406112148480.22470@scotdoyle.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com> <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com> <20140604083726.GN1730@lahna.fi.intel.com> <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
 <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com> <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com> <20140609124700.GJ1657@lahna.fi.intel.com> <alpine.DEB.2.02.1406092332410.8274@scotdoyle.com> <alpine.DEB.2.02.1406100610220.8274@scotdoyle.com>
 <20140611092309.GC1657@lahna.fi.intel.com> <alpine.DEB.2.02.1406111837030.21198@scotdoyle.com> <CANLzEkuGWd9s1Ka32BrgGxrCF+gGqVA4=uKuGJMerWaz6NDMpA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Jun 2014, Benson Leung wrote:
> On Wed, Jun 11, 2014 at 10:51 AM, Scot Doyle <lkml14@scotdoyle.com> wrote:
>> The chromeos_laptop module probes the first i2c adapter with a specific name
>> for expected hardware. However, the Acer C720 Chromebook has two i2c
>> adapters with the same name. This patch probes each i2c adapter with a
>> specific name until locating the expected hardware.
>>
>> Thanks to Mika Westerberg for formatting tips and identifying the need for
>> unique bus addresses within each set of identically-named adapters.
>
> Scot,
>
> Is your intention with this patch to replace the one that Mika wrote
> that specifically special cased the designware i2c busses? He already
> solved this problem in this patch.
> https://patchwork.kernel.org/patch/4288591/
>
> I'm not sure about your approach here. It looks like if there's some
> ambiguity in the names of the busses, you try to probe the device on
> every bus with that name.
>
> We know that bus 0 is going to have the touchpad, and we know that bus
> 1 is going to have the touchscreen and light sensor. I'd prefer not to
> send extra probes for all of the combination of devices that don't
> exist.

In the case of the Acer C720, will the touchpad always be the first device 
iterated by the bus_find_device function?

My quite possibly incorrect understanding is that:
- the i2c bus numbers assigned are dynamic
- dynamic bus numbers depend on the order of device registration
- there is no guarantee of the ordering of device registration
- bus_find_device iterates by insertion order (as opposed to ascending pci 
device id or ascending pci hardware address)
