Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3L0GsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:48:21 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:56350 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3L0GsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:48:19 -0500
MIME-Version: 1.0
X-Originating-IP: [178.70.117.254]
In-Reply-To: <20130422083549.7c1cff84@notabene.brown>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
 <20130422083549.7c1cff84@notabene.brown>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Fri, 27 Dec 2013 10:48:03 +0400
X-Google-Sender-Auth: heT7sMmVN-ZhSIU6UqOlQWey8F8
Message-ID: <CACaajQtt1t-tdCrW6eCgx0_0WxTNR1buV6H2iEj_gWzrV3JZfA@mail.gmail.com>
Subject: Re: mdadm raid1 regression
To: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/22 NeilBrown <neilb@suse.de>:
> I'll try to make sure that works correctly for the next release.
> Thanks for the report.


Sorry, Neil. for bumping up old thread. I'm again have problems with
data-offset param for mdadm.
I'm using version from git master (guthub). If i try to create raid1 like
/sbin/mdadm --create --data-offset=2048 --metadata=1.2 --verbose
--force --run --bitmap=internal --assume-clean --name=md21_901
md21_901 --level=raid1 --raid-devices=2 /dev/mapper/sas00-21_901
/dev/mapper/sas01-21_901
I have
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 64e0028e:301aa3ce:cdf1a54f:a9e28f27
           Name : xen25:md21_901  (local to host xen25)
  Creation Time : Fri Dec 27 10:43:06 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 10489856 (5.00 GiB 5.37 GB)
     Array Size : 5244928 (5.00 GiB 5.37 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4008 sectors, after=0 sectors
          State : clean
    Device UUID : 38771de6:cb5f0dbc:9f32f85f:164e1e89

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Dec 27 10:43:22 2013
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 7f07eb77 - correct
         Events : 2


But when i try to create raid1 like
/sbin/mdadm --create --data-offset=1024 --metadata=1.2 --verbose
--force --run --bitmap=internal --assume-clean --name=md21_901
md21_901 --level=raid1 --raid-devices=2 /dev/mapper/sas00-21_901
/dev/mapper/sas01-21_901
I getting
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ef22dca1:1424ea9e:1b4dce89:27c61a91
           Name : xen25:md21_901  (local to host xen25)
  Creation Time : Fri Dec 27 10:44:21 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 10491904 (5.00 GiB 5.37 GB)
     Array Size : 5245952 (5.00 GiB 5.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=0 sectors
          State : clean
    Device UUID : afae5e27:6c706246:4c3e3cb0:e5c726ac

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Dec 27 10:44:26 2013
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 45be4cd1 - correct
         Events : 2


Why data offset specified in command line grows twice in resulting md
array component?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
