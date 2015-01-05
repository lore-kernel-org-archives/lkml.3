Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbbAEIwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:52:23 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:48041 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbAEIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:52:21 -0500
Date: Mon, 5 Jan 2015 00:52:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] next: microblaze: Fix build failure
Message-ID: <20150105085212.GA11117@roeck-us.net>
References: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
 <20150103170118.GA8958@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103170118.GA8958@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54AA50CF.0064,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 06:01:18PM +0100, Richard Cochran wrote:
> On Sat, Jan 03, 2015 at 06:53:20AM -0800, Guenter Roeck wrote:
> > Microblaze build in linux-next fails with
> > 
> > arch/microblaze/kernel/timer.c:224:2: error:
> > 	implicit declaration of function 'timecounter_init'
> > 
> > Caused by missing include file in microblaze timer code.
> 
> Already fixed in net-next.
> 
The arm64 build is still broken in next-20150105 due to the same commit.

# bad: [35393dcb2ed331e8698a548fbba8042457f5fd32] Add linux-next specific files for 20150105
# good: [b7392d2247cfe6771f95d256374f1a8e6a6f48d6] Linux 3.19-rc2
git bisect start 'HEAD' 'v3.19-rc2'
# good: [0e549e6e3875b24240385b7d9ea6af202fe752ad] Merge remote-tracking branch 'slave-dma/next'
git bisect good 0e549e6e3875b24240385b7d9ea6af202fe752ad
# bad: [bd6327e236e94c0404af23c10e746e495a86836e] Merge remote-tracking branch 'virtio/virtio-next'
git bisect bad bd6327e236e94c0404af23c10e746e495a86836e
# bad: [f06c56ffe334bf2ae5ddde68f2321ec2f59bddd9] Merge remote-tracking branch 'bluetooth/master'
git bisect bad f06c56ffe334bf2ae5ddde68f2321ec2f59bddd9
# bad: [6c032edc8a338f7a5d7bbd3dd8a08ac80d37dd86] Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
git bisect bad 6c032edc8a338f7a5d7bbd3dd8a08ac80d37dd86
# bad: [01aa29978bda1978aaf56452122881a678f5dfd5] Merge branch 'gmac-next'
git bisect bad 01aa29978bda1978aaf56452122881a678f5dfd5
# bad: [87897931c83038af4931990af5b9365b41829921] tun: Fixed unsigned/signed comparison
git bisect bad 87897931c83038af4931990af5b9365b41829921
# bad: [fea3cb063bf9b9d6b4efd5c973217a708812f5e2] ksz884x: Use setup_timer
git bisect bad fea3cb063bf9b9d6b4efd5c973217a708812f5e2
# bad: [5ee698e3677a1af8b731cc891e94be33b6572cfd] net: igb: convert to timecounter adjtime.
git bisect bad 5ee698e3677a1af8b731cc891e94be33b6572cfd
# bad: [8b976e97772cfb7e0e4eb8682d5017861dbd8796] net: xgbe: convert to timecounter adjtime.
git bisect bad 8b976e97772cfb7e0e4eb8682d5017861dbd8796
# bad: [796c1efd6fa0ed696d550b68f4410ab1a1749d01] timecounter: provide a helper function to shift the time.
git bisect bad 796c1efd6fa0ed696d550b68f4410ab1a1749d01
# bad: [74d23cc704d19732e70ef1579a669f7d5f09dd9a] time: move the timecounter/cyclecounter code into its own file.
git bisect bad 74d23cc704d19732e70ef1579a669f7d5f09dd9a
# first bad commit: [74d23cc704d19732e70ef1579a669f7d5f09dd9a] time: move the timecounter/cyclecounter code into its own file.

Did you fix that already as well ?

Thanks,
Guenter
