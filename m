Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3D2Mg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3D2Mg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:36:57 -0400
Date: Mon, 29 Apr 2013 14:36:51 +0200
From: Karel Zak <kzak@redhat.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130429123651.GA2400@x2.net.home>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be>
 <1366924229-21569-3-git-send-email-phdm@macqel.be>
 <20130429093756.GB12317@x2.net.home>
 <20130429114041.GA10884@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429114041.GA10884@frolo.macqel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 01:40:41PM +0200, Philippe De Muyter wrote:
> > why not memset(pps_found, ....)? I also see magical constant 16
> 
> Actually 16 is the maximum partition count allowed in a disk by linux,
> or should it be 15 ?  Is there already a constant for that ?
> The AIX disk I tested with had only :) 11 partitions.

I don't think it's correct to expect any hardcoded limit. 
 
The struct parsed_partitions->parts is allocated according to
disk_max_parts() where the limit depends on number of minor numbers or
it's DISK_MAX_PARTS (=256).

There is no problem to create disk with many partitions:

 # modprobe scsi_debug dev_size_mb=300
 # (echo -e 'g\n'; for i in {1..100}; do echo -e "n\n\n\n+1M"; done; \
    echo -e 'w\nq\n') | fdisk /dev/sdb

 # lsblk -n /dev/sdb | wc -l
 101

 Note it's fdisk with GPT support.

> > Philippe, do you have any disk image with AIX LVM? It would be nice to
> > have a way how to test the code. I'd like to add support for AIX to
> > libblkid too.
> 
> Of course.  But that's not a couple of blocks.  I'll try to cut the
> slice that you need.

 Cool!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
