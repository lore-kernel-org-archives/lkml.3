Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3JaTnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:43:51 -0400
Received: from science.horizon.com ([71.41.210.146]:56220 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752674Ab3JaTnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:43:50 -0400
Date: 31 Oct 2013 15:43:48 -0400
Message-ID: <20131031194348.29940.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: adilger@dilger.ca, linux@horizon.com
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
In-Reply-To: <A80E174D-DCB8-41B2-84DF-38CAB9473AEE@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger asked:
> What kind of storage stack is underneath this filesystem?  If
> it is deep (e.g. DM + LVM + iSCSI) then the stack overflow is
> definitely possible.

ext4 on md raid1 on SATA.  Nothing too complicated.

Personalities : [raid0] [raid1] 
md1 : active raid1 sdb2[1] sda2[0]	# Root partition
      41942976 blocks [2/2] [UU]
      
md2 : active raid1 sdb3[1] sda3[0]	# /home partition
      100663232 blocks [2/2] [UU]
      
md0 : active raid1 sdb1[1] sda1[0]	# Swap partition
      25165696 blocks [2/2] [UU]
      
unused devices: <none>


There's 8G of RAM, and a large swap partition because I download
a lot of videos to tmpfs on /tmp.  (/tmp is capped at 16G, and swap
is 24G, so I shouldn't run out, but there was certainly quite
a few GB of stuff there.)
