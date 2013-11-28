Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3K1NH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:07:29 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:32783 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab3K1NH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:07:27 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com> <yq1iovclm0m.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1iovclm0m.fsf@sermon.lab.mkp.net>
Subject: RE: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 28 Nov 2013 08:07:24 -0500
Message-ID: <00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQIRpMQ5yoPFWdrjnTAKydtw81oUOQGvynbamaeryiA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com] 
Sent: Thursday, November 28, 2013 8:00 AM
To: Justin Piszcz
Cc: open list; linux-ext4@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx
driver

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Justin> Relevant logs: [178339.353519] 3w-sas: scsi0: ERROR:
Justin> (0x03:0x0101): Invalid command opcode:opcode=0x41.
Justin> [178339.353565] sda2: WRITE SAME failed. Manually zeroing.

Justin> Is this something I should be worried about? 

No, it just means that your 3ware controller does not handle the WRITE
SAME command and we fall back to manually writing out zeroes.

I posted a patch a while back that prevents WRITE SAME being issued for
controllers that do not pass the commands through to disk directly:

	http://marc.info/?l=linux-scsi&m=138252394614920&w=2

[ .. ]

Awesome, thank you!  This patch is over a month old, do you know if is
currently in mainline?  I'll also update my case with 3ware/LSI.

Justin.

