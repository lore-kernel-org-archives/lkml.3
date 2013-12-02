Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3LBO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3LBO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:28:39 -0500
Date: Mon, 2 Dec 2013 09:28:29 -0500
From: Dave Jones <davej@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: HID: kye: Add report fixup for Genius Manticore Keyboard
Message-ID: <20131202142829.GA2411@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
References: <20131128051223.28802660D26@gitolite.kernel.org>
 <20131130214211.GA16854@redhat.com>
 <alpine.LNX.2.00.1312021515300.24931@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1312021515300.24931@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:16:24PM +0100, Jiri Kosina wrote:
 > On Sat, 30 Nov 2013, Dave Jones wrote:
 > 
 > >  > Commit:     4a2c94c9b6c03af61b04993340bd9559e2277de4
 > >  > Author:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
 > >  > AuthorDate: Wed Nov 20 09:49:41 2013 -0500
 > >  > Committer:  Jiri Kosina <jkosina@suse.cz>
 > >  > CommitDate: Thu Nov 21 10:28:58 2013 +0100
 > >  > 
 > >  >     HID: kye: Add report fixup for Genius Manticore Keyboard
 > >  >     
 > >  >     Genius Manticore Keyboard presents the same problem in its report
 > >  >     descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
 > >  >     Use the same fixup.
 > > 
 > > ..
 > > 
 > >  > diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
 > >  > index 7384512..35a4f9c 100644
 > >  > --- a/drivers/hid/hid-kye.c
 > >  > +++ b/drivers/hid/hid-kye.c
 > >  > @@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 > >  >  	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 > >  >  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 > >  >  					"Genius Gx Imperator Keyboard");
 > >  > +	case USB_DEVICE_ID_GENIUS_MANTICORE:
 > >  > +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
 > >  > +					"Genius Manticore Keyboard");
 > >  >  		break;
 > > 
 > > 
 > > Is the IMPERATOR case supposed to fall-through to MANTICORE here, or is there a missing break ?
 > > The commit text describes using the same fixup, but has this alternative case.
 > 
 > I am almost certain that the missing break is a mistake, and the offsets 
 > in both report descriptors are just different, and there is no need for 
 > two fixups.
 > 
 > I am queuing this for 3.13 still, but having final confirmation from 
 > Benjamin would of course be nice.

If that is the case..

-- 


Commit 4a2c94c9b6 inadvertantly removed a break from the GENIUS_GX_IMPERATOR case.
Spotted by Coverity.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index ecb5ca669e97..e77696367591 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -341,6 +341,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 					"Genius Gx Imperator Keyboard");
+		break;
 	case USB_DEVICE_ID_GENIUS_MANTICORE:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
 					"Genius Manticore Keyboard");

