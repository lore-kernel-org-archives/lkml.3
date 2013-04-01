Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab3DAQ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:26:26 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:63362 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3DAQ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:26:24 -0400
Message-ID: <5159B52D.3050601@lwfinger.net>
Date: Mon, 01 Apr 2013 11:26:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "'George0505'" <george0505@realtek.com>,
        Joon Ro <joonhyoung.ro@gmail.com>
Subject: Linux driver for Realtek RTL8723AU devices with USB ID 0bda:1724
 such as found in Lenovo IdeaPad Yoga 13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After receiving a number of inquiries regarding a Linux driver for the RTL8723AU 
device with USB ID 0bda:1724, I asked my contacts in the USB group at Realtek if 
such a driver were available. They responded that there is one, but not on their 
public FTP site; however, they gave me the necessary info to get it from their 
private site, and also granted permission for me to make it publicly available.

Therefore, I have created a git repository that can be copied using the command:

git clone http://github.com/lwfinger/rtl8723au.git

Once cloned, the command sequence 'make && sudo make install' in the resulting 
source directory will build and install the driver, which is named 8723au. At 
the moment, it does not require external firmware. The driver will build on all 
kernel versions up to, and including 3.9. I have not tested on kernels older 
than 3.7, but the code contains conditional statements testing against kernel 
2.6.18. It should build on any kernel new enough for the base hardware.

My plan is to evolve this driver into a form that is suitable for inclusion in 
the staging tree of the kernel; however, that will take some effort and time, 
which is why I am making the intermediate results available now. As that work 
proceeds, the git version will evolve into code that can be submitted to the 
kernel with only small changes.

Please be aware that I do not have any hardware that uses this driver, thus I 
can only guarantee that the code compiles; however, Joon Ro has tested the 
driver and he assures me that it works. Together we have been eliminating 
spurious log entries.

The 8723a chip also includes Bluetooth hardware. I have not received any 
indication that it is active in the RTL8723AU, but it certainly is in the 
RTL8723AE, the PCIe version. In a separate activity, I am working with Realtek 
to prepare a kernel driver for this portion of the device.

I welcome your comments, bug reports, patches, suggestions for changes, and 
testing. In addition, please spread the word to anyone that has been seeking 
this driver.

Thanks,

Larry
