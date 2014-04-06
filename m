Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaDFUb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:31:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaDFUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:31:25 -0400
Message-ID: <5341B999.3050206@infradead.org>
Date: Sun, 06 Apr 2014 13:31:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig circular dependency question
References: <5341AFC7.1070001@lwfinger.net>
In-Reply-To: <5341AFC7.1070001@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 12:49 PM, Larry Finger wrote:
> A kernel build is reporting the following:
> 
> net/rfkill/Kconfig:4:error: recursive dependency detected!
> net/rfkill/Kconfig:4:   symbol RFKILL is selected by R8723AU
> drivers/staging/rtl8723au/Kconfig:1:    symbol R8723AU depends on USB
> drivers/usb/Kconfig:41: symbol USB is selected by MOUSE_APPLETOUCH
> drivers/input/mouse/Kconfig:162:        symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:        symbol INPUT is selected by ACPI_CMPC
> drivers/platform/x86/Kconfig:635:       symbol ACPI_CMPC depends on RFKILL
> 
> What is the recommended way to avoid this circularity? Of course, R8723AU could select USB rather than depending on it, but that does not seem quite right.

I don't know if it will fix the problem, but Linus has spoken (written)
against selecting subsystems, like INPUT or USB.

Does changing ACPI_CMPC to depend on INPUT instead of select INPUT
help?
and/or changing MOUSE_APPLETOUCH to depend on USB instead of select it?


-- 
~Randy
