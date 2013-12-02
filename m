Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3LBOQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:16:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3LBOQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:16:30 -0500
Date: Mon, 2 Dec 2013 15:16:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: HID: kye: Add report fixup for Genius Manticore Keyboard
In-Reply-To: <20131130214211.GA16854@redhat.com>
Message-ID: <alpine.LNX.2.00.1312021515300.24931@pobox.suse.cz>
References: <20131128051223.28802660D26@gitolite.kernel.org> <20131130214211.GA16854@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Dave Jones wrote:

>  > Commit:     4a2c94c9b6c03af61b04993340bd9559e2277de4
>  > Author:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
>  > AuthorDate: Wed Nov 20 09:49:41 2013 -0500
>  > Committer:  Jiri Kosina <jkosina@suse.cz>
>  > CommitDate: Thu Nov 21 10:28:58 2013 +0100
>  > 
>  >     HID: kye: Add report fixup for Genius Manticore Keyboard
>  >     
>  >     Genius Manticore Keyboard presents the same problem in its report
>  >     descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
>  >     Use the same fixup.
> 
> ..
> 
>  > diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
>  > index 7384512..35a4f9c 100644
>  > --- a/drivers/hid/hid-kye.c
>  > +++ b/drivers/hid/hid-kye.c
>  > @@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  >  	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
>  >  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
>  >  					"Genius Gx Imperator Keyboard");
>  > +	case USB_DEVICE_ID_GENIUS_MANTICORE:
>  > +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
>  > +					"Genius Manticore Keyboard");
>  >  		break;
> 
> 
> Is the IMPERATOR case supposed to fall-through to MANTICORE here, or is there a missing break ?
> The commit text describes using the same fixup, but has this alternative case.

I am almost certain that the missing break is a mistake, and the offsets 
in both report descriptors are just different, and there is no need for 
two fixups.

I am queuing this for 3.13 still, but having final confirmation from 
Benjamin would of course be nice.

Thanks,

-- 
Jiri Kosina
SUSE Labs
