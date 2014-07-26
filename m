Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaGZMXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 08:23:53 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:47706 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaGZMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 08:23:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2014 14:24:10 +0200
From: Stefan Agner <stefan@agner.ch>
To: Peter Chen <peter.chen@freescale.com>
Cc: s.hauer@pengutronix.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        b35083@freescale.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] vf610: Add USB support
In-Reply-To: <20140722001322.GA6636@shlinux1.ap.freescale.net>
References: <cover.1405702442.git.stefan@agner.ch>
 <20140722001322.GA6636@shlinux1.ap.freescale.net>
Message-ID: <8d6b79304e78ba664d0500b653d25db3@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-22 02:13, schrieb Peter Chen:
> On Fri, Jul 18, 2014 at 07:01:36PM +0200, Stefan Agner wrote:
>> This patchset adds USB support for Vybrid VF610 SoC. It extends the
>> clock framework to support the USB PHY cocks, extends the device
>> tree files and adds support for the non-core registers in the
>> usbmisc_imx driver.
>>
>> This patchset needs the eSDHC length fix available in Shawn's
>> for-next branch.
>>
> 
> Why it is related to USB patchset?
> 

The eSDHC registers are just in front of the USB registers. Due to the
wrong length, the two register areas overlapped, hence the second driver
(and I think it was USB which was loaded second) could not probe
successfully.

>> The whole patchset proved to be working on a Colibri VF61. The
>> first USB controller runs in peripheral mode. I could successfully
>> use RNDIS, however with some stability issues: Suddenly the other
>> side was not reachable anymore and the interface needed to brought
>> down and back up again. I'm still investigating this.
> 
> Do you use ubuntu as host distribution? I find ubuntu will lost the
> first connection for usb-ethernet-gadget(usb0) as network interface,
> but once you re-config usb0 again (ifconfig usb0 ip up), it should work
> and will not lose connection any more.
> 

I use a Angstrom build, an OpenEmbedded distribution. I restarted the
link using ip link set dev usb0 up/down, this brought the link back in a
pingable state, however even afterwards after some seconds of iperf, the
link hanged again...

--
Stefan
