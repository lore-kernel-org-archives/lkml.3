Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaGTPKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 11:10:39 -0400
Received: from nm37.bullet.mail.ne1.yahoo.com ([98.138.229.30]:35294 "EHLO
	nm37.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbaGTPKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 11:10:35 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 11:10:34 EDT
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 735128.89855.bm@omp1001.bt.mail.ir2.yahoo.com
X-YMail-OSG: m_YW2cgVM1nFoDxdeNX0_rEPzQPnzoqQK5eGgIJ16F5e53H
 l1JqXwR67OJnCxN1uC1aXFntoA5Z0PsZCuuGNvHOqFuuXtDd3ZDrzXsLCpkV
 jexfJKc4gH6JiR.hEc7vsgFHPvN4K7eIUsBrGIeexNmSa0y_eXz1gWrXmtW4
 amq2_c3JSPzqZ4MfbXr2jwgzhuoIKCMtln49GZ6dSb9OCkWtOaYCrxCwz1sq
 e2.xOhRhqjcGEUB_6zwbofA6ZcG04NMMPghHD0NgzDGN6ogL5232FmwcuhWi
 YTOlWykVkv0DcHSFjUPs9_3UQJb42JIYULW5MxeDLpF3yoBuif9iiot5ZHGi
 IghxR15dbUfR6FKQDJT0ZMK8SGVjvHY4_P42YIv2jZ1j0G5Hmj8OBLIzPj72
 oGDkZCl7yoVFbbDf3Td3C6nrF2VKaPQTNlMko_87ElWElHBqacnzlSxk63Xd
 svjODKeSLnb_hW4c7IPA7OG2btkyi8n34xsxrxnomxPnZqZgF3TLsr.nrSu4
 .8PmRd87QpW0kVLPhrjacMfKwC1GfeG__tq8D2Ae7IT8fsa7W.kiIegYeYHn
 1hYsLOU5Th3nKzgEgJgBbir9_gueNfMuabD6E
X-Rocket-MIMEInfo: 002.001,CgpIaSBhbGwsCgpJJ3ZlIGdvdCBhbiBIUCBQYXZpbGlvbiAxMSB4MzYwIGxhcHRvcCB3aGljaCBzb21ldGltZXMgZmFpbHMgdG8gYm9vdCBhbmQgd2hlbiBpdCBkb2VzIGJvb3Qgd2lsbCBhbHdheXMgaGFuZyBvbiBzaHV0ZG93bi4KVGhpcyBzZWVtcyB0byBiZSBhIGNvbW1vbiBpc3N1ZSBvbiBhIGJ1bmNoIG9mIG5ld2VyIEhQIGxhcHRvcHMgYW5kIHRoZXJlIGFyZSBxdWl0ZSBhIGZldyByZXBvcnRzIGluIHRoZSB2YXJpb3VzIGRpc3RybyBidWcgdHJhY2tpbmcgc3lzdGVtcy4KCkkndmUgd29ya2VkIG91dCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.195.680
Message-ID: <1405868470.28439.YahooMailNeo@web87404.mail.ir2.yahoo.com>
Date: Sun, 20 Jul 2014 16:01:10 +0100
From: Scott Ashcroft <scott.ashcroft@talk21.com>
Reply-To: Scott Ashcroft <scott.ashcroft@talk21.com>
Subject: HP Pavilion 11 x360 lockups on shutdown
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi all,

I've got an HP Pavilion 11 x360 laptop which sometimes fails to boot and when it does boot will always hang on shutdown.
This seems to be a common issue on a bunch of newer HP laptops and there are quite a few reports in the various distro bug tracking systems.

I've worked out that the issue is with the dw_dmac module. If I rmmod it there's an instant lockup.
Blacklisting that module makes everything work correctly. Booting is reliable, shutdown and reboot work fine.

I'd like some advice on how this should be fixed:

I see that some very similar chipsets would cause the i2c_designware-pci driver to be loaded where as mine loads the platform device.

So is the correct fix to get some PCI ids and settings added to the PCI driver?

Or should I be looking to add a DMI based blacklist to stop the i2c bus being detected at all.


Or is this just a bug in the dw_dmac module. If so how can I get any debug out of it during the rmmod?

Cheers,
Scott
