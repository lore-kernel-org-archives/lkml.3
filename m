Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3EZI7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 04:59:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65535 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab3EZI7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 04:59:09 -0400
References: <alpine.DEB.2.02.1305260712220.8957@shack.dolda2000.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <alpine.DEB.2.02.1305260712220.8957@shack.dolda2000.com>
Content-Type: text/plain;
	charset=GB2312
Content-Transfer-Encoding: 8BIT
Message-Id: <99E50EC5-59B7-45D5-95A6-0C861C5C8AB3@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (10B329)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: Weird disk idling
Date: Sun, 26 May 2013 16:58:59 +0800
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fred，
      How do you know the disk is completely idle ? How much cache memory do your controller and disk have ?  Why do you think the requests should trigger action of disk immediately while you don't know what kind of requests are they. They are reading the same offset of the same block ?

  ... ....

    Before got the answer, you should ask yourself many questions.


Ethan 

发自我的 iPad

在 2013-5-26，13:29，Fredrik Tolf <fredrik@dolda2000.com> 写道：

> Dear list,
> 
> In order to debug I/O performance, I recently wrote a tiny program for inspecting /sys/block/$DISK/stat. It works by dumping deltas of the values every 100 ms, quite simply (except the queue-length value, for which deltas are clearly useless).
> 
> Using this, I often see periods during constant I/O loads where there are lots of requests in the queue, but the disk is completely idle. They usually last somewhere from 0.1 to 2 seconds. Using the aforementioned program, they might look, for instance, like this:
> 
> 1369545418.8       0        0        0        0        2        0       16     4888      134      100    13400
> 1369545418.9       0        0        0        0        0        0        0        0      134      100    13400
> 1369545419.0       0        0        0        0        0        0        0        0      135      104    13984
> 1369545419.1       0        0        0        0        0        0        0        0      135      100    13500
> 1369545419.2       0        0        0        0        0        0        0        0      135      100    13500
> 1369545419.3       0        0        0        0        0        0        0        0      135      100    13500
> 1369545419.4       0        0        0        0        0        0        0        0      135      100    13500
> 1369545419.5       0        0        0        0        0        0        0        0      135      100    13500
> 1369545419.6       0        0        0        0        0        0        0        0      135      104    14040
> 1369545419.7       2        0       64      672       58        0     1185   152512       78      100    11296
> 
> I'm sure you all know what the various fields are (except the first, which is just a timestamp), so as you can see, there are 135 requests in the queue, but no reads or writes happen, in this case, for at least 800 ms.
> 
> Is this behavior normal and expected, or is there something wrong here? In the latter case, is it my hardware that is failing somehow, or can there be some software weirdness that can be tweaked away or bugfixed?
> 
> The disk in question is a 640 GB WDC Caviar Green, and it's attached via an old Silicon Image 3114 PCI card. Clearly, the hardware is less than optimal, but can that explain this behavior? (For the record, the disk does at least not report any SMART errors, and there are no errors about in the dmesg.)
> 
> The kernel version is 3.7.1, and the scheduler is CFQ.
> 
> Thanks for reading!
> 
> --
> 
> Fredrik Tolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
