Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3BPREL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:04:11 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59688 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3BPREK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:04:10 -0500
Message-ID: <511FBBF7.2020103@gmail.com>
Date: Sat, 16 Feb 2013 18:03:51 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: regmap: Question about devices with unequal register sizes
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark and everyone,

I'm writing a driver for an I2C audio codec which has an unusual
register map. The datasheet can be found here:

  http://www.ti.com/lit/gpn/tas5086

The register layout is described on page 26, and they call their
registers 'subaddresses'. Up to sub-address 0x1c, I see no problem
mapping that to a simple 8-bit regmap layout, but above that, access
gets trickier because registers change their sizes, which breaks the cache.

So for example, in order to set the 'Downmix input MUX register', the
host is expected to send the sub-address 0x21, followed by 4 consecutive
bytes containing the values. 0x21 is, however, not the correct offset in
the register cache, as 0x20 ('Input MUX register') is also 4 bytes in
size. Higher registers also have to be written in 20 byte blocks.

I thought about registering multiple regmaps with the i2c device, but
that turns out not to play well with ASoC, which always takes the first
regmap for the device.

Are ranges within in the regmap_config what I want here? I haven't yet
figured how to use them accordingly though.

Thanks for sharing any ideas.


Best regards,
Daniel
