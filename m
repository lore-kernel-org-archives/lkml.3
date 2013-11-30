Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab3K3VmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 16:42:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3K3VmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:42:21 -0500
Date: Sat, 30 Nov 2013 16:42:11 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: HID: kye: Add report fixup for Genius Manticore Keyboard
Message-ID: <20131130214211.GA16854@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>
References: <20131128051223.28802660D26@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128051223.28802660D26@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Commit:     4a2c94c9b6c03af61b04993340bd9559e2277de4
 > Author:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
 > AuthorDate: Wed Nov 20 09:49:41 2013 -0500
 > Committer:  Jiri Kosina <jkosina@suse.cz>
 > CommitDate: Thu Nov 21 10:28:58 2013 +0100
 > 
 >     HID: kye: Add report fixup for Genius Manticore Keyboard
 >     
 >     Genius Manticore Keyboard presents the same problem in its report
 >     descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
 >     Use the same fixup.

..

 > diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
 > index 7384512..35a4f9c 100644
 > --- a/drivers/hid/hid-kye.c
 > +++ b/drivers/hid/hid-kye.c
 > @@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 >  	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 >  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 >  					"Genius Gx Imperator Keyboard");
 > +	case USB_DEVICE_ID_GENIUS_MANTICORE:
 > +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
 > +					"Genius Manticore Keyboard");
 >  		break;


Is the IMPERATOR case supposed to fall-through to MANTICORE here, or is there a missing break ?
The commit text describes using the same fixup, but has this alternative case.

	Dave

