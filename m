Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaC3JXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 05:23:10 -0400
Received: from mail.tomasu.net ([192.241.222.217]:44894 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaC3JXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 05:23:08 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2014 05:23:08 EDT
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: LKML <linux-kernel@vger.kernel.org>
Reply-To: thomas@fjellstrom.ca
Subject: turbo on lenovo w530 causing over-temp warnings
Date: Sun, 30 Mar 2014 03:13:57 -0600
Message-ID: <2113542.FNB0FtJayJ@balsa>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a lenovo w530 laptop with an intel i7-3720QM processor, and when 
running something with high cpu use causes the cpu to be put into the highest 
turbo mode and stays there as long as the core is being used. It doesn't scale 
back to the real max frequency once temperatures rise.

I've had my laptop shut itself down after a few minutes due to a thermal 
warning a few times. I was attempting to try the latest stable stock (non 
debian) kernel to see if maybe it was a weird distro config issue (it happens), 
but as I was compiling the kernel, CPU temps hit 90c, and were climbing after 
only a few minutes. If I had let it go longer, I am 100% sure it would have 
shut itself off again.

I just tried seeing what would happen if I just ran a straight up make on the 
kernel with no -j option. So only one core at a time would be pegged, and it 
caused all 4 cores to spike to 3.4Ghz+ and stay there till I killed the job.

Is this a known problem? Is there something obvious I've missed?

I've been trying to find relevant info online about this, but a lot of it is 
fairly old and references the intel_pstep driver causing tubo to be stuck on 
100% of the time. In my case its only stuck at full turbo while there is a 
certain amount of cpu use. It does drop back if nothing is running.

Currently running kernel is the debian 3.13.7-1 kernel from sid. I will 
attempt to try the stock latest stable, as well as the latest rc, but I won't 
be able to get around to both till tomorrow.

Thanks.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
