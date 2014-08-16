Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaHPPif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:38:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52540 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaHPPid (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:38:33 -0400
Message-ID: <53EF7AF6.2000405@gmail.com>
Date: Sat, 16 Aug 2014 17:38:30 +0200
From: Philippe Reynes <tremyfr@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        shawn.guo@freescale.com, Peter.Chen@freescale.com
CC: gwenhael.goavec-merou@trabucayre.com
Subject: [RFC] usb issue on imx27: 3 clocks are needed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and usb_div)
but the current chipidea driver implementation, and devicetree, provides
only ipg and ahb. Consequently, if the bootloader don't enable the last
one, the kernel will crash.

Our approach/idea is to add a second, optionnal, clock in ci_hdrc_imx.c
with 'per' name in devicetree  and to add  clock name 'main_clk' for mandatory clock.
                   
This approach it correct? Or an other approach seems better?
                            
Thank you very much for your point of view.

Regards,
Philippe and Gwenhael
