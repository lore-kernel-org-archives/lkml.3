Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaGWDGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:06:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:18923 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbaGWDG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:06:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565820935"
Message-ID: <53CF26B2.6060503@linux.intel.com>
Date: Wed, 23 Jul 2014 11:06:26 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com> <20140722012352.GD6822@agk-dp.fab.redhat.com>
In-Reply-To: <20140722012352.GD6822@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/22 9:23, Alasdair G Kergon wrote:
>>>> On 2014/7/9 6:39, Mikulas Patocka wrote:
>>> Which ioctl with more than 16kB
>>> arguments do you use?
> Unanswered.  Let's ask the same question in a different way:
>
> Please supply the output of these three commands on the real-world system on
> which you believe that that particular allocation is causing you a problem:
>    dmsetup info -c
>    dmsetup table
>    dmsetup status

Android doesn't include the command. We compiled lvm2-2_02_107.tar.gz and copy
dmsetup to the board. But command reports No devices.

# /data/bin/dmsetup info
No devices found

# cat /proc/devices
Character devices:
   1 mem
   4 /dev/vc/0
   4 tty
   4 ttyS
   4 ttyMFD
   5 /dev/tty
   5 /dev/console
   5 /dev/ptmx
   7 vcs
  10 misc
  13 input
  21 sg
  29 fb
  81 video4linux
  89 i2c
108 ppp
116 alsa
128 ptm
136 pts
153 spi
166 ttyACM
180 usb
188 ttyUSB
189 usb_device
202 cpu/msr
203 cpu/cpuid
226 drm
241 mdm_ctrl
242 sep54
243 roccat
244 hidraw
245 ttyGS
246 usbmon
247 ttyPTI
248 gsmtty
249 bsg
250 iio
251 ptp
252 pps
253 media
254 rtc

Block devices:
   1 ramdisk
259 blkext
   7 loop
   8 sd
   9 md
  11 sr
  65 sd
  66 sd
  67 sd
  68 sd
  69 sd
  70 sd
  71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
179 mmc
253 device-mapper
254 mdp

