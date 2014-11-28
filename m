Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaK1WQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:16:17 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30558 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:16:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Bi+OiBW3TcNZBeAj7eRh0
Date: Fri, 28 Nov 2014 14:13:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: Alexander Kochetkov <al.kochet@gmail.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [RFC] i2c: omap: TEST: do IP reset during probe.
Message-ID: <20141128221350.GW2817@atomide.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <1417028722-29306-1-git-send-email-al.kochet@gmail.com>
 <7hzjbdd57j.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hzjbdd57j.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@kernel.org> [141126 13:27]:
> Alexander Kochetkov <al.kochet@gmail.com> writes:
> 
> > NOT FOR UPSTREAM
> >
> > The patch checks if IP reset during probe could bring I2C bus
> > to a free state on omap2430 - omap3530 boards.
> >
> > I guess, IP hold one of I2C lines in a low state.
> > I guess, u-boot haven't sent a stop condition.
> >
> > The patch is rebased on branch 'i2c/for-next' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> > (6e79807443cba7397cd855ed29d6faba51d4c893)
> >
> > Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> > Reported-by: Kevin Hilman <khilman@kernel.org>
> > Tested-by: Kevin Hilman <khilman@kernel.org>
> 
> Built for omap2plus_defconfig and tested on all my OMAP boards.  Results
> here:
> 
> http://people.linaro.org/~khilman/tmp/next-20141126-1-g760388ee02e4/arm-omap2plus_defconfig/

And below is the output from 2430sdp with linux next plus Alexander's
test patch. Looks like for some time 2430 i2c has not been behaving
reliably unless I force compatible to ti,omap2420-i2c instead of
ti,omap2430-i2c.. The output below is with ti,omap2430-i2c.

Regards,

Tony

8< -------------
[    0.913574] omap_i2c 48070000.i2c: init0: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:493)
[    1.931365] omap_i2c 48070000.i2c: timeout waiting for bus ready
[    1.931457] omap_i2c 48070000.i2c: init1: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:497)
[    1.931518] omap_i2c 48070000.i2c: init1: bb_valid=0
[    2.949249] omap_i2c 48070000.i2c: timeout waiting for bus ready
[    2.949340] omap_i2c 48070000.i2c: init2: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:504)
[    2.949401] omap_i2c 48070000.i2c: init2: bb_valid=0
[    2.952941] omap_i2c 48070000.i2c: bus 0 rev3.3 at 100 kHz (rev 00000036)
[    2.969299] omap_i2c 48072000.i2c: init0: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:493)
[    3.987091] omap_i2c 48072000.i2c: timeout waiting for bus ready
[    3.987182] omap_i2c 48072000.i2c: init1: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:497)
[    3.987243] omap_i2c 48072000.i2c: init1: bb_valid=0
[    5.004974] omap_i2c 48072000.i2c: timeout waiting for bus ready
[    5.005096] omap_i2c 48072000.i2c: init2: STAT=0x0000; IE=0x601f; CON=0x8000; SYSTEST=0x0000; SDA=00 [OI]; SCL=00 [OI] (omap_i2c_init:504)
[    5.005126] omap_i2c 48072000.i2c: init2: bb_valid=0
[    5.017517] omap_i2c 48072000.i2c: bus 1 rev3.3 at 100 kHz (rev 00000036)
[    7.555419] twl4030_keypad 48072000.i2c:twl@48:keypad: OF: linux,keymap property not defined in /ocp/i2c@48072000/twl@48/keypad
[    7.567626] twl4030_keypad 48072000.i2c:twl@48:keypad: Failed to build keymap
[    7.575439] twl4030_keypad: probe of 48072000.i2c:twl@48:keypad failed with error -2
[    7.599639] input: twl4030_pwrbutton as /devices/platform/ocp/48072000.i2c/i2c-1/1-0048/48072000.i2c:twl@48:pwrbutton/input/input1
[    7.624450] twl_rtc 48072000.i2c:twl@48:rtc: Power up reset detected.
[    7.631988] twl_rtc 48072000.i2c:twl@48:rtc: Enabling TWL-RTC
[    7.655456] twl_rtc 48072000.i2c:twl@48:rtc: rtc core: registered 48072000.i2c:twl@48 as rtc0
[    7.923187] i2c /dev entries driver
[    8.246795] twl_rtc 48072000.i2c:twl@48:rtc: hctosys: unable to read the hardware clock
[    9.675994] omap_i2c 48072000.i2c: controller timed out
[   10.704010] omap_i2c 48072000.i2c: controller timed out
[   11.734069] omap_i2c 48072000.i2c: controller timed out
root@omap2430sdp:/# [   12.823638] omap_i2c 48072000.i2c: controller timed out
[   12.834747] twl4030: I2C error -110 reading PIH ISR
