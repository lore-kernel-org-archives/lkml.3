Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaE2QFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:05:22 -0400
Received: from mx2.netorek.fi ([213.157.84.84]:41953 "EHLO mx2.netorek.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213AbaE2QFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:05:17 -0400
Date: Mon, 12 Jun 2006 01:06:30 -0400
From: Maurice Volaski <mvolaski@aecom.yu.edu>
To: drbd-user@linbit.com
Cc: linux-kernel@vger.kernel.org
Subject: [DRBD-user] Spontaneous access to the CDROM on two computers	simultaneously
Message-Id: <20140529153602.54154205E72@mx2.netorek.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spontaneously and for no apparent reason, two computers displayed the 
following message in their logs several times at the same time:

[55419.446442] Buffer I/O error on device hda, logical block 0
[55419.447381] hda: command error: status=0x51 { DriveReady 
SeekComplete Error }
[55419.447386] hda: command error: error=0x54 { AbortedCommand 
LastFailedSense=0x05 }
[55419.447389] ide: failed opcode was: unknown
[55419.447391] end_request: I/O error, dev hda, sector 0

These two amd64-based computers are running kernel 2.6.16.1 with 
drbd-0.7.19. (drbd is a network RAID module; it sends data from one 
computer to the other continuously, but to its own /dev/drbdx 
devices.)

hda is the CDROM drive, so it appears that both computers all on 
their own volition attempted to access their CDROM drive for no 
reason at and the same time, nonetheless. Since neither of them has a 
CDROM in the drive at the time, I think this error makes sense if 
something internally caused a real attempt to do that.

One computer is running a variety of file sharing services (netatalk, 
samba, apache, mysql). Both of them are running heartbeat and drbd, 
and those programs should account for the only communication between 
two computers at the time of the messages, so I'm guessing that 
because of that, drbd could at least theoretically triggered this 
somehow.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
_______________________________________________
drbd-user mailing list
drbd-user@lists.linbit.com
http://lists.linbit.com/mailman/listinfo/drbd-user



