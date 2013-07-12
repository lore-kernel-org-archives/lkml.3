Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3GLEm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 00:42:29 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:54240 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3GLEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 00:42:28 -0400
MIME-Version: 1.0
Date: Thu, 11 Jul 2013 23:42:27 -0500
Message-ID: <CAPmiNYi34E6bZrPD7vOPV0HJ=7eHtNRqStdT1p2U2ET4vmx39Q@mail.gmail.com>
Subject: Re: ALSA: Conexant CX20585 (thinkpad t510) speaker powersave regression
From: Jason Schindler <jschind@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to jump into the thread from here:

http://markmail.org/message/zqbhcuc2gnxji3s7

I'm experiencing the same issue as described in the thread.  I'm
currently running kernel 3.9.6, but have had the issue for some time.

I attempted to go through the debugging requested by Takashi Iwai on Jan 13.

Immediately after issuing the "hda-verb /dev/snd/hwC0D0 0x1f
SET_POWER_STATE 0" command, here is the trace output:

# tracer: nop
#
# entries-in-buffer/entries-written: 8/8   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        hda-verb-14066 [001] .... 90509.001737: hda_power_count: [0:0]
power_count=2, power_on=1, power_transition=0
        hda-verb-14066 [001] .... 90509.001740: hda_send_cmd: [0:0] val=1f70500
        hda-verb-14066 [001] .... 90509.001814: hda_get_response: [0:0] val=0
        hda-verb-14066 [001] .... 90509.001814: hda_power_count: [0:0]
power_count=1, power_on=1, power_transition=0
        hda-verb-14122 [003] .... 90712.799801: hda_power_count: [0:0]
power_count=2, power_on=1, power_transition=0
        hda-verb-14122 [003] .... 90712.799804: hda_send_cmd: [0:0] val=1f70500
        hda-verb-14122 [003] .... 90712.799880: hda_get_response: [0:0] val=0
        hda-verb-14122 [003] .... 90712.799881: hda_power_count: [0:0]
power_count=1, power_on=1, power_transition=0

When the speakers stop, here is the output:

# tracer: nop
#
# entries-in-buffer/entries-
written: 8/8   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        hda-verb-14066 [001] .... 90509.001737: hda_power_count: [0:0]
power_count=2, power_on=1, power_transition=0
        hda-verb-14066 [001] .... 90509.001740: hda_send_cmd: [0:0] val=1f70500
        hda-verb-14066 [001] .... 90509.001814: hda_get_response: [0:0] val=0
        hda-verb-14066 [001] .... 90509.001814: hda_power_count: [0:0]
power_count=1, power_on=1, power_transition=0
        hda-verb-14122 [003] .... 90712.799801: hda_power_count: [0:0]
power_count=2, power_on=1, power_transition=0
        hda-verb-14122 [003] .... 90712.799804: hda_send_cmd: [0:0] val=1f70500
        hda-verb-14122 [003] .... 90712.799880: hda_get_response: [0:0] val=0
        hda-verb-14122 [003] .... 90712.799881: hda_power_count: [0:0]
power_count=1, power_on=1, power_transition=0

I'm a bit out of my element here, if I've missed a crucial step,
please let me know.

Thanks!

-Jason
