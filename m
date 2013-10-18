Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3JRNac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:30:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52280 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3JRNa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:30:29 -0400
Message-ID: <526137F0.2060307@gmail.com>
Date: Fri, 18 Oct 2013 22:30:24 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: dm-writeboost: unusual refcount on Raspberry Pi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I am trying to run writeboost on a tiny ARM machine, Raspberry Pi.
writeboost can compile without any error nor warning but
it doesn't even start ctr.

What I do before running `dmsetup create` is
# modprobe dm-mod
# insmod dm-writeboost.ko

After these two commands, lsmod looks insane.
I suppose dm_writeboost module's refcount should be 0, not -1 (2147483647).
Nonetheless, dmesg doesn't indicate anything at all.
If I try to make a writeboost device after this,
it hangs up the whole system.

I have no idea what is happening in my system.
If you know something about this, please help me.

root@raspberrypi:~/dm-writeboost# lsmod
Module                  Size  Used by
dm_writeboost          34473  2147483647
dm_mod                 72892  1 dm_writeboost
snd_bcm2835            16432  0
snd_pcm                77728  1 snd_bcm2835
snd_page_alloc          5169  1 snd_pcm
snd_seq                53482  0
snd_seq_device          6462  1 snd_seq
snd_timer              20110  2 snd_pcm,snd_seq
snd                    58744  5 snd_bcm2835,snd_timer,snd_pcm,snd_seq,snd_seq_device
arc4                    1684  2
rt2800usb              14948  0
rt2800lib              55431  1 rt2800usb
rt2x00usb              11240  1 rt2800usb
rt2x00lib              42342  3 rt2x00usb,rt2800lib,rt2800usb
mac80211              273979  3 rt2x00lib,rt2x00usb,rt2800lib
cfg80211              184390  2 mac80211,rt2x00lib
rfkill                 18298  2 cfg80211
crc_ccitt               1530  1 rt2800lib
leds_gpio               2243  0
led_class               3570  2 leds_gpio,rt2x00lib

Akira
