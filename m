Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3KOSsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 13:48:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3KOSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 13:48:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/3] misc: bmp085: Add DT bindings for EOC gpio line and direct irq.
Date: Fri, 15 Nov 2013 19:47:50 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marek Belisko <marek@goldelico.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "neilb@suse.de" <neilb@suse.de>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com> <1384465609-26485-3-git-send-email-marek@goldelico.com> <20131115153015.GD24831@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131115153015.GD24831@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311151947.51196.arnd@arndb.de>
X-Provags-ID: V02:K0:uVU4YpbseyG4OY3gGvpykHJcPKladbcuXq0vcE5vtwh
 LGlQF99HxdSOgUIYW+U3u/0sIjQwsG/eYtbWLSGe6sfGSc3QYx
 3/Iyfmv8prfgNgFUMk+/Esk9ZZbGrS8WDPA5kNjkYKB6vGNlXT
 7QEUys6lSWryCAlL9oaYCNGFt2T15tTrKBETVc/wBGxUhFEbW0
 LE0+x1Cu/sw04H6bzMngGaNw/39yZvlNp7AevBIK5YfXAEn6qN
 qPw5oYwEqk/6cIzg4makbOFsVabUcj+GWqIGFJNyBWEXOnIesF
 w2r7MSEpeSZ8MJSK0iT2TlXoHfPrSk3KqNbsFnojShe/fe542H
 RUB+ZFDr+ET9RHWsnORQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 November 2013, Mark Rutland wrote:
> There's some contention over the description of gpio-based IRQs in DT.
> From the point of view of the device there is a logical IRQ output; the
> fact that this happens to be wired up to a GPIO pin that can happen to
> generate interrupts isn't anything to do with the device itself. There
> are plenty of device we have now whose interrupt lines could be wired to
> GPIOs. I see no reason to extend their bindings to support explicit
> GPIOs for IRQs, and I see no reason the driver should have to handle
> this.
> 
> It would be far nicer for the device binding to just have the interrupts
> property, and for the gpio controller to act as an interrupt-controller,
> with the appropriate pin management.

Yes, agreed. I missed this point in my review: the GPIO is used only
as an interrupt pin here, so there is no reason to know the GPIO number.

	Arnd
