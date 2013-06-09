Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3FIQ2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:28:44 -0400
Received: from postout2.mail.lrz.de ([129.187.255.138]:38815 "EHLO
	postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3FIQ2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:28:43 -0400
From: "Morales, Alejandra" <alejandra.morales@tum.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Questions about Runtime Power Management
Thread-Topic: Questions about Runtime Power Management
Thread-Index: Ac5lLkRrBYfFPnaQQhqUrRlWdi6dgQ==
Date: Sun, 9 Jun 2013 16:28:21 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>
Accept-Language: es-ES, en-US
Content-Language: es-ES
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.155.5.51]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am currently involved in the implementation of my master thesis, for what I am trying to create a user space power management tool. As a part of this work I am developing a kernel module, and one of the first things I need to do is getting the current power state of some devices of my computer, essentially hard drives and network devices (ethernet and wireless cards).

For the hard drives, I get the pointers to the struct device that represents each one iterating over scsi_bus_type and selecting those whose driver is named "sd". Then, I obtain the runtime power state:

dev->power.runtime_status;

I did a test with an external USB hard drive, checking the runtime power state before and after issuing a sleep command with hdparm -Y. The drive effectively spinned down, but the runtime power state didn't change from active to suspended.

In the case of net devices, I get the corresponding structures this way:

struct net_device *netdev = first_net_device(&init_net);
    
while (netdev) {

        struct device *dev = &netdev->dev;
        
        /* code... */

        netdev = next_net_device(netdev);
}

For every net_device I get its embedded struct device and then I check the same field as before, but in this case runtime power management is disabled, so I always get the device is suspended, even though it is configured and working properly. In fact, the whole device struct seems to be empty.  

Taking this into account, my questions are:

- Is it possible that I am not getting the correct struct device for every hardware device?
- Am I checking the correct field of the struct dev_pm_info?
- Do scsi device drivers implement the runtime_status updates when drives effectively change their state?
- Is runtime power management supported by net devices?

Any answer would be really appreciated. Thanks in advance.

Best regards,

Alejandra Morales Ruiz
Master Thesis Student
Technische Universität München
Fakultät für Informatik
