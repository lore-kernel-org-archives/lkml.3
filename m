Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbaKANlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 09:41:17 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:40809 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbaKANlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 09:41:16 -0400
X-SourceIP: 2001:470:25:65c::2
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <5454E2F3.2060404@odi.ch>
Date: Sat, 01 Nov 2014 14:41:07 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [drm] 3.18 regression: backlight dark after resume
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 3.18-rc1 backlight is dark after resume from suspend. This is on a Samsung 
laptop with i5 IvyBridge

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor 
Graphics Controller (rev 09)


I have bisected this problem to the following commit:
73580fb764c4213d305c0d36bd8f856ae631eb42 is the first bad commit
commit 73580fb764c4213d305c0d36bd8f856ae631eb42
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Tue Aug 12 17:11:41 2014 +0300

     drm/i915/dp: make backlight bl_power control power sequencer backlight

     This lets the userspace switch off the backlight using the backlight
     class sysfs bl_power file. The switch is done using the power sequencer;
     the backlight PWM, and everything else, remains enabled. The display
     backlight won't draw power, but for maximum power savings the encoder
     needs to be switched off.

     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
     Reviewed_by: Clinton Taylor <Clinton.A.Taylor@intel.com>
     Tested_by: Clinton Taylor <Clinton.A.Taylor@intel.com>
     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>


Thanks,

Ortwin
