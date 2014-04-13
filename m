Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaDMTGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 15:06:37 -0400
Received: from www84.your-server.de ([213.133.104.84]:60980 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDMTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 15:06:36 -0400
Message-ID: <1397415946.1555.16.camel@vger.seibold.net>
Subject: X86: Impossible select Enhanced Real Time Clock Support (legacy PC
 RTC driver)
From: Stefani Seibold <stefani@seibold.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        a.zummo@towertech.it
Date: Sun, 13 Apr 2014 21:05:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since some kernel version it is impossible to select the Enhanced Real
Time Clock Support (legacy PC RTC driver) because RTC_LIB is set by
default in arch/x86/Kconfig, but the rule for selecting CONFIG_RTC is
RTC_LIB=n. So the code of driver/char/rtc is still useless.

This breaks the API since there is no more misc device /dev/rtc
available without a udev rule or a link to /dev/rtc0. 


