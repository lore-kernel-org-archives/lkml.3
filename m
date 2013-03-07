Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3CGPHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:07:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3CGPHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:07:42 -0500
Date: Thu, 7 Mar 2013 16:07:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Bowles <bobjohnbowles@gmail.com>
Subject: Re: [PATCH] HID: logitech-dj: do not directly call hid_output_raw_report()
 during probe
In-Reply-To: <1362499740-32459-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1303071600480.28677@pobox.suse.cz>
References: <1362499740-32459-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Mar 2013, Benjamin Tissoires wrote:

> hid_output_raw_report() makes a direct call to usb_control_msg(). However,
> some USB3 boards have shown that the usb device is not ready during the
> .probe(). This blocks the entire usb device, and the paired mice, keyboards
> are not functional. The dmesg output is the following:
> 
> [   11.912287] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-2/input2
> [   11.912537] logitech-djreceiver 0003:046D:C52B.0003: logi_dj_probe:logi_dj_recv_query_paired_devices error:-32
> [   11.912636] logitech-djreceiver: probe of 0003:046D:C52B.0003 failed with error -32
> 
> Relying on the scheduled call to .hid_hw_request() fixes the problem.
> 
> related bugs:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143
> https://bugzilla.redhat.com/show_bug.cgi?id=840391
> https://bugzilla.kernel.org/show_bug.cgi?id=49781
> 
> Reported-and-tested-by: Bob Bowles <bobjohnbowles@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi guys,
> 
> this bug has taken too long to be solved. I managed to figure out the root cause
> recently thanks to the work of Jelle Foks in lp#1039143.
> 
> Jiri, I based this fix on top of your for-3.10/logitech branch.
> It *will* failed to build when you will merge it with the branch
> for-3.10/hid-driver-transport-cleanups. This is due to the use of
> usbhid_submit_report() instead of hid_hw_request(). The 
> 
> However, I prefer do it that way so that I can send it to "stable" to fix all
> the current releases since 3.2 (I guess only the LTS v3.4 will pick it and the
> current 3.8, but distros can then cherry-pick it easily).

Benjamin, Bob,

excellent work, thanks for figuring it out.

Given the nature of the bug, I'd prefer to push it to Linus for 3.9 still, 
and have it backported to -stable as well.

Once it's in Linus' tree, I will handle the fallout in 
for-3.10/hid-driver-transport-cleanups and fix the build.

Ok?

Now queued for 3.9.

-- 
Jiri Kosina
SUSE Labs
