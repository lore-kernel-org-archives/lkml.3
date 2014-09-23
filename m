Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaIWSYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:24:23 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46874 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbaIWSYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:24:22 -0400
X-Greylist: delayed 1682 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 14:24:21 EDT
Message-ID: <5421B4B0.1020306@dev.rtsoft.ru>
Date: Tue, 23 Sep 2014 21:58:08 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gennady Kuznetsov <kuznetsovg@dev.rtsoft.ru>,
        Aleksey Makarov <amakarov@dev.rtsoft.ru>
Subject: Device tree vs hardware configurations
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm currently forward-porting a BSP for imx6-based custom board from 
pre-devicetree kernel to modern kernel.

In old BSP there was a board setup file, that registered all board's 
devices. For new BSP, I need to replace that with device tree based 
solution.

However, old BSP used conditional code to register devices differently 
based on GPIO inputs and on kernel command line. This approach was used to

- handle board's jumper that switches SPI CS lines: current jumper 
setting is available over gpio, depending on that old BSP registered 
chips differently,

- handle different i2c connections on different board revisions: board 
has 5 i2c busses with quite a few devices connected, these busses are 
routed to different hardware busses on different board revisions, board 
revision could be read over gpios.

- handle different possible display connections (lvds vs lcd, 6bit vs 
8bit hw interface) based on kernel command line options

- handle different possible camera connections by registered camera 
differently based on kernel command line option

... and more,


Device tree describes hardware unconditionally. I already have to 
provide 2 dts files for imx6q and imx6dl based setups (both just include 
a common dtsi) ...  But providing separate dts file for every possible 
hardware configuration will result into 2^n device trees, which is 
inconvenient visible regression against old BSP that "just worked" on 
all hardware configurations.


Is there a sane way to handle hardware configurations like above in 
device tree based kernel?


Nikita Yushchenko
