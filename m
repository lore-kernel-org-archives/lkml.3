Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3CKIIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:08:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:28701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKIH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="276178332"
Message-ID: <1362989331.5101.41.camel@sauron.fi.intel.com>
Subject: Re: Bug in mtd_get_device_size()?
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Genoud <richard.genoud@gmail.com>,
        "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
Cc: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>
Date: Mon, 11 Mar 2013 10:08:51 +0200
In-Reply-To: <CACQ1gAhJzy5tGSuejc3GqaqRxtHvkABOY-tODzedveeRXddvxQ@mail.gmail.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
	 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
	 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
	 <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
	 <CACQ1gAhJzy5tGSuejc3GqaqRxtHvkABOY-tODzedveeRXddvxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 15:29 +0100, Richard Genoud wrote:
> > Unfortunately I have no additional information why it happened, but
> anyway is it really necessary to runs ubiformat+ubimkvol for such
> cases? Or is it possible to recover data?
> I honestly don't know, but I'm sure Artem has some idea on that.

Everything should work in theory. If there are issues, they should be
looked at and investigated. I do not have any better suggestion off the
top of my head.

> >Since my solution for this case is to put the device data in separate MTD with one single UBI volume. But you know how much space I should reserve on NAND MTD for single XML-File with 200Bytes :-).
> I've got the same problem with uboot environment for example. It's
> only some hundred bytes, and still I have to reserve the maximum bad
> blocks number + 1 for the environment itself (so for your device 41).
> I know, this looks overkill...
> For 200bytes, I would try to store them elsewhere (spi dataflash,
> eeprom...) if there's such devices on your board.
> There's also the 1st block of the nand device which is guaranteed to
> be "valid" for 1000 erase cycles (valid with 1-bit ECC per 528 bytes)

The ideal solution would be to not partition the chip at all, of course.

BTW, if we ara talking about a device for medicine with tens of years of
lifetime, you need to be careful about read disturb issues. In the MTD
web site we discuss them - and there is a suggestion to read whole UBI
device from time to time to force scrubbing.

> > Alternative is to try to mount only device volume, copy data in tmpfs, run ubiformat+ubimkvol+mount and copy the data back to the device volume. Or you have other idea?

Not sure why this would be needed. We did not do any on-flash format
breakage AFAIK. But I admit I did not read this thread carefully.

Sergey, feel free to ask specific questions in separate threads, to make
it easier to answer them.

-- 
Best Regards,
Artem Bityutskiy

