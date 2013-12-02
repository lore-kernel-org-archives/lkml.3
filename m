Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3LBOc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:32:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3LBOc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:32:56 -0500
Message-ID: <529C9A15.4030000@redhat.com>
Date: Mon, 02 Dec 2013 09:32:53 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HID: kye: Add report fixup for Genius Manticore Keyboard
References: <20131128051223.28802660D26@gitolite.kernel.org> <20131130214211.GA16854@redhat.com> <alpine.LNX.2.00.1312021515300.24931@pobox.suse.cz> <20131202142829.GA2411@redhat.com>
In-Reply-To: <20131202142829.GA2411@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/13 09:28, Dave Jones wrote:
> On Mon, Dec 02, 2013 at 03:16:24PM +0100, Jiri Kosina wrote:
>  > On Sat, 30 Nov 2013, Dave Jones wrote:
>  > 
>  > >  > Commit:     4a2c94c9b6c03af61b04993340bd9559e2277de4
>  > >  > Author:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
>  > >  > AuthorDate: Wed Nov 20 09:49:41 2013 -0500
>  > >  > Committer:  Jiri Kosina <jkosina@suse.cz>
>  > >  > CommitDate: Thu Nov 21 10:28:58 2013 +0100
>  > >  > 
>  > >  >     HID: kye: Add report fixup for Genius Manticore Keyboard
>  > >  >     
>  > >  >     Genius Manticore Keyboard presents the same problem in its report
>  > >  >     descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
>  > >  >     Use the same fixup.
>  > > 
>  > > ..
>  > > 
>  > >  > diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
>  > >  > index 7384512..35a4f9c 100644
>  > >  > --- a/drivers/hid/hid-kye.c
>  > >  > +++ b/drivers/hid/hid-kye.c
>  > >  > @@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  > >  >  	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
>  > >  >  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
>  > >  >  					"Genius Gx Imperator Keyboard");
>  > >  > +	case USB_DEVICE_ID_GENIUS_MANTICORE:
>  > >  > +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
>  > >  > +					"Genius Manticore Keyboard");
>  > >  >  		break;
>  > > 
>  > > 
>  > > Is the IMPERATOR case supposed to fall-through to MANTICORE here, or is there a missing break ?
>  > > The commit text describes using the same fixup, but has this alternative case.
>  > 
>  > I am almost certain that the missing break is a mistake, and the offsets 
>  > in both report descriptors are just different, and there is no need for 
>  > two fixups.
>  > 
>  > I am queuing this for 3.13 still, but having final confirmation from 
>  > Benjamin would of course be nice.
> 
> If that is the case..
> 

Hi guys,

(sorry for the late answer, last week was Thanksgiving, and I was
enjoying US public holidays)

Definitively, this is my mistake. Thanks Dave for spotting it.

Jiri, I'll try to hold on the 3.12 stable queue on this one too (or ask
to add Dave's patch).

Cheers,
Benjamin
