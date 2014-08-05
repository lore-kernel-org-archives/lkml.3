Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaHEIoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:44:46 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:47096 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaHEIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:44:43 -0400
Date: Tue, 5 Aug 2014 10:44:38 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <75613802.20140805104438@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, gregkh@linuxfoundation.org,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
In-Reply-To: <20140804184318.GB9009@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com> <53DBB27D.2040203@citrix.com> <20140804184318.GB9009@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, August 4, 2014, 8:43:18 PM, you wrote:

> On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
>> > Greg: goto GHK
>> > 
>> > This is v5 version of patches to fix some issues in Xen PCIback.
>> 
>> Applied to devel/for-linus-3.17.

> Thank you.
>> 
>> I dropped the stable Cc for #2 pending a final decision on whether it
>> really is a stable candidate.

> OK.
>> 
>> David

Hi Konrad / David,

This series still lacks a resolution on the sysfs /do_flr /reset,
as a result the pci devices are not reset after shutdown of a guest.
(no more pciback 0000:xx:xx.x: restoring config space at offset xxx)

So this series now introduces a regression to 3.16, which causes devices to malfunction 
after a guest reboot or after assigning the devices to another guest.

Apart from that .. i can't resist to remind the other issue with removing pci
devices passed through to HVM guests related to the signaling via xenstore,
described in:

http://lists.xen.org/archives/html/xen-devel/2014-07/msg01875.html 


--
Sander


