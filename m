Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3DLX3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:29:04 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:64152 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3DLX3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:29:01 -0400
Message-ID: <516898BE.8040209@prisktech.co.nz>
Date: Sat, 13 Apr 2013 11:29:02 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: scott.liu@emc.com.tw
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v3] Support Elan Touchscreen eKTF product.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

Not sure what is happening with the patch - seems to have been sitting 
for quite a while. Is it still being worked on?
I integrated it into our arm/arch-vt8500 testing tree (based on 3.9-rc6) 
as we have tablets with eKTF2127 controllers and noticed a few problems.

1) __devxxxx attributes cause unused function warnings because they are 
deprecated.

2) elants_get_power_state() is only called from elants_resume() which is 
contained within a #ifdef CONFIG_PM_SLEEP. You should also move the 
elants_get_power_state() inside the #ifdef to remove the unused_function 
warning when compiled without CONFIG_PM.

Regards
Tony Prisk
