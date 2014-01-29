Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaA2PCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:02:33 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40535 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaA2PCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:02:31 -0500
Date: Wed, 29 Jan 2014 17:02:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFCv2,1/2] v4l2-controls.h: add addtional Flash fault bits
Message-ID: <20140129150225.GB14729@valkosipuli.retiisi.org.uk>
References: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
 <20140128090841.GG13820@valkosipuli.retiisi.org.uk>
 <52E78418.3000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E78418.3000302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Jan 28, 2014 at 07:19:04PM +0900, Daniel Jeong wrote:
> 2014년 01월 28일 18:08, Sakari Ailus 쓴 글:
> >Hi Daniel,
> >
> >On Tue, Jan 28, 2014 at 03:55:57PM +0900, Daniel Jeong wrote:
> >>Add additional FLASH Fault bits to dectect faults from chip.
> >>Some Flash drivers support UVLO, IVFM, NTC Trip faults.
> >>UVLO : 	Under Voltage Lock Out Threshold crossed
> >>IVFM : 	IVFM block reported and/or adjusted LED current Input Voltage Flash Monitor trip threshold
> >>NTC  : 	NTC Threshold crossed. Many Flash drivers have a pin and the fault bit to
> >>serves as a threshold detector for negative temperature coefficient (NTC) thermistors.
> >>
> >>Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> >>---
> >>  include/uapi/linux/v4l2-controls.h |    3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >>diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> >>index 1666aab..01d730c 100644
> >>--- a/include/uapi/linux/v4l2-controls.h
> >>+++ b/include/uapi/linux/v4l2-controls.h
> >>@@ -803,6 +803,9 @@ enum v4l2_flash_strobe_source {
> >>  #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
> >>  #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
> >>  #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
> >>+#define V4L2_FLASH_FAULT_UVLO			(1 << 6)
> >>+#define V4L2_FLASH_FAULT_IVFM			(1 << 7)
> >>+#define V4L2_FLASH_FAULT_NTC_TRIP		(1 << 8)
> >I object adding a new fault which is essentially the same as an existing
> >fault, V4L2_FLASH_FAULT_OVER_TEMPERATURE.
> 
> I hope you consider it again.
> Usually, when the die temperature exceeds the specific temperature, ie 120 or 135 and fixed value,
> turn off PFET,NFET, current sources and set TEMP Fault bit.
> But in the NTC mode, the comparator is working and detect selected temperature through Vtrip value.
> It protects shutdown the chip due to high voltage and keep the device operation.
> Many flash chip support NTC and TEMP Fault both. For example, LM3554, LM3556, LM3559
> LM3642, LM3646, LM3560, LM3561, LM3565 etc
> Two things should be tell apart.

Ah, after looking at the specs I now understand what you do mean. This is
about the temperature of the LED, not the flash controller chip itself.

The actual implementation appears to be an NTC resistor.

How about V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE?

> >As the practice has been to use human-readable names for the faults, I'd
> >also suggest using V4L2_FLASH_FAULT_UNDER_VOLTAGE instead of
> >V4L2_FLASH_FAULT_UVLO.
> 
> I agree with you.
> 
> >
> >What's the IVFM block and what does it do?
> 
> IVFM is Input Voltage Flash Monitor.
> If the flash chip has IVFM function the flash current can be adjusted based upon the voltage level of input.
> As ramping flash current, the input voltage goes down and IVFM block adjust current to prevent to shudown due to low voltage
> and keep the flash operation. So if the input voltage crossed the IVFM Threshold level chip set the fault bit.
> Many flash chip, for example LM3556, LM3646, LM3642 , support this fucntion.
> I think, V4L2_FLASH_FAULT_INPUT_VOLTAGE_MONITOR is better than V4L2_FLASH_FAULT_IVFM.

What would you think of V4L2_FLASH_FAULT_INPUT_VOLTAGE?

"Input voltage monitor" looks like a chip specific term; another chip could
well use something else.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
