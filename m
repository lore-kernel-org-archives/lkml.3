Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3JVHDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:03:08 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:15024 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab3JVHDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:03:06 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-193.messagelabs.com!1382425382!13247005!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 22 Oct 2013 09:03:03 +0200
Date: Tue, 22 Oct 2013 09:02:56 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Michael Buesch <m@bues.ch>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: Driver Design Question
Message-ID: <20131022070256.GA5527@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 22 Oct 2013 07:01:37.0364 (UTC) FILETIME=[8D05E940:01CECEF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

I have a design question concerning a device driver. The device in question is
somewhere in between drivers/mfd/timberdale and drivers/ssb. It is mapped
connected via PCI and on PCI Bar 0 there is a table describing which
"sub-devices" are contained in the FPGA as well as where their Memory and IRQ
resources are.

Unlike the timberdale driver, there is no static configuration of the FPGA's
sub-devices, but their number and kind is variable. But luckily we have unique
device-ids for every sub-device, so it is possible to do a PCI/USB like
enumeration.

In my understanding the MFD API, which timberdale uses, isn't tailored to this
Plug'n'Play like behavior. Whereas the I think (virtual) bus concept used by
SSB is much more suited for this kind of devices. But would it be wise to add a
bus only suited to devices manufactured by one vendor, when there is already a
API for such kinds of multi function devices?

Long story short, which would be the preferred way to implement such a driver? At
the point I currently reached I could go in both directions.

I'd appreciate any advice I can get on this topic.

Thanks in advance,

       Johannes

P.S.: MFD and SSB maintainers are on CC as I'd really like to hear their opinion
