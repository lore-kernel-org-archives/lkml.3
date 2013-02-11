Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3BKP54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:57:56 -0500
Received: from mail1.sysgo.com ([176.9.26.183]:36634 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3BKP5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:57:55 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 10:57:55 EST
Message-ID: <511912BB.2060602@sysgo.com>
Date: Mon, 11 Feb 2013 16:48:11 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: timekeeping_adjust may set mult to 0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have encountered a problem when a linux system uses a clocksource with 
mult = 1 and shift = 0 (clocksource cycle = nanoseconds). It may happen 
that the function timekeeping_adjust reduces the value of mult to 0 when 
error is lower than the interval [1].
As soon as timekeeper.mult is 0, ktime_get will no longer work because 
it uses timekeeping_get_ns which converts the cycle to nanoseconds with 
mult as 0 and the system clocksource returns always 0.

Best regards
David Engraf


[1] http://lxr.linux.no/linux+v3.0.62/kernel/time/timekeeping.c#L821
