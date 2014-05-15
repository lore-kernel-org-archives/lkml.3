Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaEOQp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:45:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58318 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaEOQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:45:25 -0400
Message-ID: <5374EF1A.2000609@gmail.com>
Date: Thu, 15 May 2014 22:15:14 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it
Subject: query regarding not returning error if request_irq fails after rtc
 registration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in ds1343 driver after the rtc is registered using devm_rtc_device_register
i am requesting irq using devm_request_threaded_irq, in case this request
fails instead of the driver bailing out it just uses dev_err to show the
error and the driver probe returns zero

my question is that the set_alarm and alarm_irq_enable is still active,
so should i use some flag in the global private variable of the driver
so that if the request irq fails, then using this flag the set_alarm
and alarm_irq_enable can return error since there is no irq handler
for the rtc interrupt 
or is there any other solution 
or let the set_alarm and alarm_irq_enable routine be as it is and will
not harm 

Thanks and Regards
Raghavendra Chandra Ganiga
Contact: +919594554858
