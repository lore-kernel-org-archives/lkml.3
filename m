Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbaE2QFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:05:35 -0400
Received: from mx2.netorek.fi ([213.157.84.84]:41981 "EHLO mx2.netorek.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbaE2QFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:05:17 -0400
Date: Sat, 17 Jun 2006 14:20:28 -0400
From: Maurice Volaski <mvolaski@aecom.yu.edu>
To: drbd-user@linbit.com
Cc: gentoo-user@lists.gentoo.org, linux-kernel@vger.kernel.org,
        linux-lvm@redhat.com
Subject: [DRBD-user] Re: Spontaneous access to the CDROM on two computers simultaneously
Message-Id: <20140529153604.5FC52205E8A@mx2.netorek.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It happened again, but this time on just one of the two computers:

[20770.844282] hda: tray open
[20770.844288] end_request: I/O error, dev hda, sector 0
[20770.844292] Buffer I/O error on device hda, logical block 0

Since you think LVM may be misbehaving, I changed the filter on the 
affected computer to read

filter = [ "r|/dev/cdrom|", "r|/dev/hda|", "r|/dev/ide|" ]

Ironically, that's on the computer that threw the error, so it could 
be more evidence LVM has a problem if it is indeed the cause or 
further evidence that it isn't involved.

The kernel on this amd64-based computer is now 2.6.16.20. LVM is 
version 2.02.05 (versions from Gentoo packages). Device mapper is 
1.02.07 and udev is 090.) Since I'm shooting in the dark, cc'd to the 
gentoo ml since this system is gentoo-based (2005.0 profile).


>/ 2006-06-12 01:06:30 -0400
>\ Maurice Volaski:
>>  Spontaneously and for no apparent reason, two computers displayed 
>>the following message in their logs several times at the same time:
>>
>  > [55419.446442] Buffer I/O error on device hda, logical block 0
>  > [55419.447381] hda: command error: status=0x51 { DriveReady 
>SeekComplete Error }
>>  [55419.447386] hda: command error: error=0x54 { AbortedCommand 
>>LastFailedSense=0x05 }
>>  [55419.447389] ide: failed opcode was: unknown
>>  [55419.447391] end_request: I/O error, dev hda, sector 0
>>
>...
>>  drbd could at least theoretically triggered this somehow.
>no.
>
>much more likely some program scanning ("discovering") devices.
>
>just a wild guess:
>man lvm.conf
>/filter

-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
_______________________________________________
drbd-user mailing list
drbd-user@lists.linbit.com
http://lists.linbit.com/mailman/listinfo/drbd-user



