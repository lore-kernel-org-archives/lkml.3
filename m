Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3JGLxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:53:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:35071 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3JGLxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:53:19 -0400
Date: Mon, 7 Oct 2013 13:53:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Felipe Balbi <balbi@ti.com>
Subject: Testing ti_am335x_adc continuous mode (WAS: Re: [PATCH 2/2]
Message-ID: <20131007115317.GA6135@linutronix.de>
References: <1379503383-17086-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com>
iio: ti_am335x_adc: Add continuous sampling support)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zubair,

I have here am335x-evm board. The output of voltage4 (via `cat
/sys/bus/iio/devices/iio\:device0/in_voltage4_raw´) returns values in
the range 570…580. I tested the continuous sampling mdoe by executing
the following commands:

|echo 1 > /sys/bus/iio/devices/iio\:device0/scan_elements/in_voltage4_en
|echo 25 > /sys/bus/iio/devices/iio\:device0/buffer/length
|echo 1 > /sys/bus/iio/devices/iio\:device0/buffer/enable
|sleep 1
|echo 0 > /sys/bus/iio/devices/iio\:device0/buffer/enable
|cat /dev/iio\:device0 > iio
|hexdump -C iio

and the output is:
|00000000  37 02 92 02 1f 07 0a 06  20 06 31 06 2f 07 2a 07
|00000010  2b 07 2d 07 2c 07 28 07  2c 07 2b 07 2b 07 0c 06
|00000020  21 06 32 06 2e 07 2c 07  2a 07 2a 07 2c 07 2b 07
|00000030  29 07 27 07 28 07 29 07  2a 07 0d 06 21 06 35 06

The first entry is in the range that I would expect. The second is
slitghly higher. The third and following entries are out of range. Have
you observed something like that? Is my testing close to what you have
done or did I make an mistake here?

Sebastian
