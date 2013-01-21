Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3AUPIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:08:42 -0500
Received: from mail.palosanto.com ([201.234.196.171]:39549 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3AUPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:08:41 -0500
Message-ID: <50FD59F7.7000308@palosanto.com>
Date: Mon, 21 Jan 2013 10:08:39 -0500
From: =?UTF-8?B?QWxleCBWaWxsYWPDrcKtcyBMYXNzbw==?= 
	<a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel command line parameter parsing is broken at drm_kms_helper.edid_firmware
 when compiling under Fedora 18
References: <50FB4697.1050907@palosanto.com>
In-Reply-To: <50FB4697.1050907@palosanto.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 19/01/13 20:21, Alex Villacís Lasso escribió:
> I am having this strange issue. My computer has a LCD display that does not send any EDID, and therefore I need the command parameter "drm_kms_helper.edid_firmware=edid/1280x1024.bin" In Fedora 16, the stock kernel does not have 
> CONFIG_DRM_LOAD_EDID_FIRMWARE set. Therefore I compiled my own kernel from vanilla sources, and the parameter worked. I have just now upgraded to Fedora 18. The new stock kernel is supposed to have CONFIG_DRM_LOAD_EDID_FIRMWARE set, but when I boot with 
> the drm_kms_helper parameter, I get a message "drm_kms_helper: Unknown parameter `bin'". I thought this was a kernel bug caused by some patch in the stock kernel, so I filed https://bugzilla.redhat.com/show_bug.cgi?id=901899 , and then proceeded to 
> compile 3.8-rc4 from vanilla sources. However, I am surprised to find that the vanilla sources, when compiled under Fedora 18, exhibit the same bug. Has anyone seen a situation like this? Is this a possible compiler bug in Fedora 18? A grub2 bug? 
> Apparently the kernel is misparsing the commandline parameter and thinks "bin" is the module parameter, not "edid_firmware".
BTW, I have CONFIG_DYNAMIC_DEBUG=y in my kernel config, and I tried adding dyndbg="file params.c +p" to the kernel command line, but I see no additional debug output that might point out what is happening.
