Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3FYGSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:18:51 -0400
Received: from nm29-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.122]:45160 "EHLO
	nm29-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab3FYGSu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:18:50 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 02:18:50 EDT
X-Yahoo-Newman-Id: 809660.47096.bm@smtp204.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1HUlPcQVM1k4b8P6bbA.41g4pPyycNEin4K0cu_mCpF1Tdi
 pWgdQ3rkhtxnLtchl0GrYk5IZ3Jo2IbUAxGQQAHBN6wOB.YSugiJ0AjG77Q1
 0say_HcDMXgQkZSjkkezFHKQGlG7QZX.uESlG383wxdstJSslWSJBRWl01W1
 ahxR7Tx1GuAXwGp8zqfg2lAGAYi8hlzycnfnm7Ff0nRPP.I5FOXa86gqBDxk
 TaOuZJqpYyzTkTCD5t1WtcRPpFuTqHdnfv3WCPaxo09A0ukzL5nD1oTukZuz
 N4MblbuLn9za9gaBVM8P9ErMxn5W2DdC59TDKu4CBNhDTVMmuG86gADgmDog
 gQqWABCLbZDLHj8ih0jACZefOuO8v7nNH3WVNHGlewkEMXxDtvee6Wfbfv26
 6b3kp0Ww0SMQSIyOikNanDhcLJMCUzzyEG1ac_RLvnNuZ0eE5FAy9MSZ.ahv
 F_5hZLDUMy0tsKf5M4RwcdCiwPox1rlXdZkIjxfj4lZ83iMcCc94qVsy_xJX
 JM1MG
X-Yahoo-SMTP: izt95ZKswBDBT1bN16dPvD5jLHMKn5IFkJA-
X-Rocket-Received: from [192.168.0.100] (james.georgas@174.3.232.145 with )
        by smtp204.mail.ne1.yahoo.com with SMTP; 24 Jun 2013 23:12:54 -0700 PDT
From: James Georgas <james.georgas@yahoo.ca>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Integrated MegaRAID controller and AMD IOMMU issue
Message-Id: <FA29E63A-76F3-4F53-8945-59E47BC8C4E4@yahoo.ca>
Date: Tue, 25 Jun 2013 00:12:53 -0600
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Supermicro H8DG6-F board, which has an LSI  SAS2008 RAID controller on it with the optional RAID5 hardware key installed. I have set up a three disk RAID5 array, using the LSI WebBIOS utility.

My kernel is configured with the MEGARAID_SAS driver. The driver picks up the RAID5 array, and I can read and write it with no problems. (In fact, my root filesystem is on a JBOD disk attached to the same controller, and I have no problems with it). However, as soon as I enable the AMD IOMMU in the kernel, bad things start to happen. The driver still picks up the RAID5 array, but any attempt to access it causes the machine to become non-responsive, and I have recover via hard reset.

I discussed the issue with an LSI engineer, and he said that since the integrated controller uses system memory, which it gets from the BIOS during initialization, there will be issues with the IOMMU. I assume he is referring to DMA address problems due to IOMMU translation.

My question is: is this something that can be addressed in the kernel drivers (MEGARAID_SAS or AMD_IOMMU), for example by protecting the LSI controller's memory resources from the IOMMU, or am I just out of luck here?

Cheers,
	James