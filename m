Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3ETUI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:08:28 -0400
Received: from avasout03.plus.net ([84.93.230.244]:35372 "EHLO
	avasout03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3ETUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:08:26 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2013 16:08:26 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.1 cv=Wq0Sb7vv c=1 sm=1 tr=0
 a=/q3kRMlYFX0Q8ZQTxlcwmA==:117 a=/q3kRMlYFX0Q8ZQTxlcwmA==:17 a=0Bzu9jTXAAAA:8
 a=_iRu-ZNsktkA:10 a=jLF5jyXfaKQA:10 a=8nJEP1OIZ-IA:10 a=GS055jfFAAAA:8
 a=mux_Gf2z7sEA:10 a=Jt44_EUB8d0rMNsl84cA:9 a=wPNLvfGTeEIA:10
Message-ID: <519A8144.8070005@Hendrik.org.uk>
Date: Mon, 20 May 2013 21:02:12 +0100
From: John Harrison <LKML@Hendrik.org.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: System hang running 'smartctl -l xerror'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a very reproducible problem such that running 'smartctl -l 
xerror,1 /dev/sd#' while other disk activity is occurring will cause a 
complete system hang. The access light for the disk being queried 
remains lit (the others are off) and there is no response on the 
keyboard. No messages are printed to the console. The only thing I can 
do is power cycle the system.

This is on an Intel Atom D945GCLF2 motherboard with an add in SiI 3124 
SATA controller. Both of the motherboard channels and three of the SiI 
channels have disks attached (one Samsung, four WD). Three of the WD 
disks are an MD raid set. The system is running Debian 'testing'. It was 
kernel version 3.2.23 but I have just upgraded to 3.2.41 (the latest 
Debian kernel source package) and the problem still occurs.

I have searched the mailing list but can't spot anything that looks 
similar. Note that the system is running fine in other respects. The 
hang only happens when querying the SMART log during a period of high 
disk activity.


Thanks,
John.

