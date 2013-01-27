Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3A0TnC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:43:02 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:36749 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3A0TnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:43:01 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 14:43:00 EST
Message-ID: <510581A0.2080801@hauke-m.de>
Date: Sun, 27 Jan 2013 20:36:00 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: zbr@ioremap.net, panto@antoniou-consulting.com,
        Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org
Subject: section mismatch in drivers/w1/masters/w1-gpio.c
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when building 3.8-rc5 I get the following section mismatch:

WARNING: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in
reference from the variable w1_gpio_driver to the function
.init.text:w1_gpio_probe()
The variable w1_gpio_driver references
the function __init w1_gpio_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console


The __init in front of w1_gpio_probe() should be removed.

Hauke
