Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KOWhC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:37:02 -0500
Received: from senator.holtmann.net ([87.106.208.187]:46901 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KOWgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:36:54 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <6C5AC1E9-D9A0-473A-B47A-345018DFAC3C@holtmann.org>
Date: Sat, 16 Nov 2013 07:36:31 +0900
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        Johan Hedberg <johan.hedberg@intel.com>, Yu-Chen Cho <acho@suse.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        jay.hung@mediatek.com
Content-Transfer-Encoding: 8BIT
Message-Id: <324E99F5-B9B7-4E56-BE91-42964AFF5BA8@holtmann.org>
References: <1384517231-1605-1-git-send-email-geert@linux-m68k.org> <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org> <20131115130820.GS5302@mwanda> <F615BA13-BEC1-457B-8002-BC6C149039EA@holtmann.org> <20131115212936.GC14897@kroah.com> <6C5AC1E9-D9A0-473A-B47A-345018DFAC3C@holtmann.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>>>>> while this is patch is correct, I do not really care about staging drivers that actually bluntly violate my copyright.
>>>>> 
>>>> 
>>>> That's very cryptic.
>>>> 
>>>> What is going on here?  I googled it and I wasn't able to find what you
>>>> are talking about.  Care to give us a hint and what you want us to do
>>>> here?
>>> 
>>> the last time I checked, the majority of drivers/bluetooth/btusb.c has been written by myself. Now go and compare btusb.c to btmtk_usb.[ch].
>>> 
>>>> I have also added Johan Hedberg to the CC list because he also helped
>>>> break the build.  Don't do that.
>>> 
>>> Yes, we are doing exactly that. It is a staging driver. I could not care less if a staging drivers breaks the build or not.
>>> 
>>> If anybody cares about this driver, then take the time to merge it upstream. It has never been submitted to linux-bluetooth mailing list.
>>> 
>>> There are drivers that should have never been merged into staging.
>>> This is one of them. Look for yourself and explain to me why this
>>> driver is part of staging in the first place.
>> 
>> Because it was sent to me by a developer?
> 
> it is a problem when staging just becomes a dumping ground for drivers that the distributions find somewhere on the Internet or CD-ROMs. And then nobody has any intentions to clean up and integrate properly. This one did not even go through linux-bluetooth mailing list once. It was submitted right to staging. And then the submitter walked away.

and if I quote the TODO file:

  TODO:
          - checkpatch.pl clean
          - determine if the driver should not be using a duplicate
            version of the usb-bluetooth interface code, but should
            be merged into the drivers/bluetooth/ directory and
            infrastructure instead.
          - review by the bluetooth developer community

  Please send any patches for this driver to Yu-Chen, Cho <acho@suse.com> and
  jay.hung@mediatek.com

So from the submission we can assume that the submitter knew that this was duplicated code. The code also never got submitted for review to linux-bluetooth. And now 6 month later, none of the TODO items have been actually worked on.

I do not know what your timeline is for removing drivers from staging, but this one seems to be a good candidate to get removed next.

Regards

Marcel

