Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaDFTtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 15:49:32 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40575 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaDFTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 15:49:29 -0400
Message-ID: <5341AFC7.1070001@lwfinger.net>
Date: Sun, 06 Apr 2014 14:49:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kconfig circular dependency question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kernel build is reporting the following:

net/rfkill/Kconfig:4:error: recursive dependency detected!
net/rfkill/Kconfig:4:   symbol RFKILL is selected by R8723AU
drivers/staging/rtl8723au/Kconfig:1:    symbol R8723AU depends on USB
drivers/usb/Kconfig:41: symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:162:        symbol MOUSE_APPLETOUCH depends on INPUT
drivers/input/Kconfig:8:        symbol INPUT is selected by ACPI_CMPC
drivers/platform/x86/Kconfig:635:       symbol ACPI_CMPC depends on RFKILL

What is the recommended way to avoid this circularity? Of course, R8723AU could 
select USB rather than depending on it, but that does not seem quite right.

Thanks,

Larry
