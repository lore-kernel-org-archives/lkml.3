Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaIGWaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 18:30:22 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:58322 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaIGWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 18:30:20 -0400
From: Nix <nix@esperi.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Oliva <oliva@gnu.org>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Looks like a broken hub? (was Re: 3.16.2: 2TiB Seagate Expansion Desk apparently still broken with both USB mass storage *and* UAS: some debugging output)
References: <Pine.LNX.4.44L0.1409071555010.404-100000@netrider.rowland.org>
	<878ulvt6vx.fsf@spindle.srvr.nix>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Date: Sun, 07 Sep 2014 23:30:06 +0100
In-Reply-To: <878ulvt6vx.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Sun, 07 Sep 2014 23:14:58 +0100")
Message-ID: <87a96bdpxt.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-scsi dropped, this is not a scsi or uas problem.]

On 7 Sep 2014, nix@esperi.org.uk stated:
> And... now it works, at least well enough to get a device file. So it's
> not the disk that's at fault: it's the no-name hub! (Which is, I think,
> USB ID 2109:0811 -- at least two instances of this disappear when I
> unplug the hub.)

Confirmed. Plugging a known-good (non-UAS) disk into the questionable
hub yields this mass of screaming:

Sep  7 23:19:29 mutilate info: : [  161.026517] usb 6-1.1.2: new SuperSpeed USB device number 5 using xhci_hcd
Sep  7 23:19:29 mutilate info: : [  161.041767] usb-storage 6-1.1.2:1.0: USB Mass Storage device detected
Sep  7 23:19:29 mutilate info: : [  161.043404] scsi8 : usb-storage 6-1.1.2:1.0
Sep  7 23:19:30 mutilate notice: : [  162.046725] scsi 8:0:0:0: Direct-Access     WD       My Book 1140     1012 PQ: 0 ANSI: 6
Sep  7 23:19:30 mutilate notice: : [  162.048476] scsi 8:0:0:1: Enclosure         WD       SES Device       1012 PQ: 0 ANSI: 6
Sep  7 23:19:30 mutilate notice: : [  162.056190] sd 8:0:0:0: [sdc] Spinning up disk...
Sep  7 23:19:30 fold warning: : [198061.014106] packet denied IN=bdsl OUT= MAC=00:00:24:cb:c6:a2:50:67:f0:8c:bf:8f:08:00 SRC=109.120.181.179 DST=81.187.191.133 LEN=28 TOS=0x00 PREC=0x00 TTL=249 ID=32820 PROTO=UDP SPT=54
642 DPT=623 LEN=8
Sep  7 23:19:39 mutilate warning: : [  163.058746] .........ready
Sep  7 23:19:39 mutilate notice: : [  171.085320] sd 8:0:0:0: [sdc] 3906963456 512-byte logical blocks: (2.00 TB/1.81 TiB)
Sep  7 23:19:39 mutilate notice: : [  171.087788] sd 8:0:0:0: [sdc] Write Protect is off
Sep  7 23:19:39 mutilate err: : [  171.090237] sd 8:0:0:0: [sdc] No Caching mode page found
Sep  7 23:19:39 mutilate err: : [  171.091720] sd 8:0:0:0: [sdc] Assuming drive cache: write through
Sep  7 23:19:39 mutilate info: : [  171.113631]  sdc: sdc1
Sep  7 23:19:39 mutilate notice: : [  171.117370] sd 8:0:0:0: [sdc] Attached SCSI disk
Sep  7 23:19:40 mutilate info: : [  171.525994] usb 6-1.1.2: reset SuperSpeed USB device number 5 using xhci_hcd
Sep  7 23:19:40 mutilate warning: : [  171.538771] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb40
Sep  7 23:19:40 mutilate warning: : [  171.540317] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb88
Sep  7 23:19:40 mutilate info: : [  171.807110] usb 6-1.1.2: reset SuperSpeed USB device number 5 using xhci_hcd
Sep  7 23:19:40 mutilate warning: : [  171.819716] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb40
Sep  7 23:19:40 mutilate warning: : [  171.821277] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb88
Sep  7 23:19:40 mutilate info: : [  172.082789] usb 6-1.1.2: reset SuperSpeed USB device number 5 using xhci_hcd
Sep  7 23:19:40 mutilate warning: : [  172.095409] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb40
Sep  7 23:19:40 mutilate warning: : [  172.097043] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb88
Sep  7 23:19:50 fold warning: : [198080.980957] packet denied IN=bdsl OUT= MAC=00:00:24:cb:c6:a2:50:67:f0:8c:bf:8f:08:00 SRC=71.6.165.200 DST=81.187.191.133 LEN=40 TOS=0x00 PREC=0x00 TTL=111 ID=8287 PROTO=TCP SPT=7987 D
PT=7071 WINDOW=60597 RES=0x00 SYN URGP=0
Sep  7 23:19:56 mutilate info: : [  188.333974] EXT4-fs (sdc1): mounted filesystem without journal. Opts: (null)
Sep  7 23:19:59 mutilate info: : [  190.584332] usb 6-1.1.2: reset SuperSpeed USB device number 5 using xhci_hcd
Sep  7 23:19:59 mutilate warning: : [  190.597220] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb40
Sep  7 23:19:59 mutilate warning: : [  190.598996] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88041b9efb88
Sep  7 23:19:59 mutilate info: : [  190.602042] sd 8:0:0:0: [sdc] Unhandled error code
Sep  7 23:19:59 mutilate info: : [  190.603677] sd 8:0:0:0: [sdc]
Sep  7 23:19:59 mutilate warning: : [  190.605251] Result: hostbyte=0x07 driverbyte=0x00
Sep  7 23:19:59 mutilate info: : [  190.606861] sd 8:0:0:0: [sdc] CDB:
Sep  7 23:19:59 mutilate warning: : [  190.608456] cdb[0]=0x28: 28 00 27 00 0c 18 00 00 f0 00
Sep  7 23:19:59 mutilate err: : [  190.610124] end_request: I/O error, dev sdc, sector 654314520

So either the hub is shagged, or the new USB extension cable that is the
only way either of these drives can physically reach the hub is shagged.
You'd think they wouldn't make hubs so bad that USB mass storage didn't
work, so maybe it's the cable?

I'll see if the new drive actually works well enough to not get horribly
corrupted doing a backup tomorrow :) if it does, I guess Alexandre's bug
is kind of fixed after all, maybe? At least with my slightly different
drive.

-- 
NULL && (void)
