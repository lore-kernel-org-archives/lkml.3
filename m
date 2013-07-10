Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3GJRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:25:27 -0400
Received: from sam.nabble.com ([216.139.236.26]:59168 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3GJRZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:25:26 -0400
Date: Wed, 10 Jul 2013 10:25:26 -0700 (PDT)
From: hyphop <email2tema@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1373477126220-681610.post@n7.nabble.com>
In-Reply-To: <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com>
References: <494703114.34959.1360492995961.JavaMail.mail@webmail19> <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello
i have same problem. low write speed after system sleep 

kernel 3.9.9

i can see it HDD SATA & USB disks to

i try to make another test  

before sleep i make  file /tmp/test ( /tmp mounted as tmpfs size=8G, i have
16G memory in my system )

dd if=/dev/zero bs=1M count=1000 of=/tmp/test 
 ~ 3,2 GB/s
cryptsetup luksFormat /tmp/test
cryptsetup luksOpen /tmp/test test

dd if=/dev/zero bs=1M count=1000 of=/dev/mapper/test
 ~ 465 GB/s good speed 

after sleep

dd if=/dev/zero bs=1M count=1000 of=/dev/mapper/test
 ~ 5MB/s ooops (((( very slow

but if write directly in /tmp i can see 

dd if=/dev/zero bs=1M count=1000 of=/tmp/test2
 ~ 3,2 GB/s

I can see this is not hardware problem (NOT SATA OR USB) i think is kernel
BUG, i i dont have this problem on previous kernel 3.4

Best regards, 

Tema






--
View this message in context: http://linux-kernel.2935.n7.nabble.com/Abysmal-HDD-USB-write-speed-after-sleep-on-a-UEFI-system-tp598586p681610.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
