Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab3GLLie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:38:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55407 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab3GLLid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:38:33 -0400
MIME-Version: 1.0
Date: Fri, 12 Jul 2013 17:08:32 +0530
Message-ID: <CAJ8eaTw9o+ZBAzR+1qe-5XEpfZzv-6DJ_EHK_BF_32-va-KL+g@mail.gmail.com>
Subject: shmem info issue
From: naveen yadav <yad.naveen@gmail.com>
To: kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi All

I am working on tmpfs. During code analysis I found shmem driver
register itself as tmpfs .

cat /proc/meminfo Shmem field read NR_SHMEM enum filed and shows used
memory in tmpfs


[root@localhost linux-3.8.2]# cat /proc/meminfo | grep -r Shmem
Shmem:               704 kB
[root@localhost linux-3.8.2]#

include/linux/mmzone.h
enum zone_stat_item {
-----cut here-------
 NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages
 -----cut here
}

I have the following query
1-> cat /proc/meminfo | grep -r Shmem show only the used tmpfs memory
or it show used  tmpfs memory + mata data also (because I found Shmem
is bit larger then tempfs used memory )
2-> as per the developer comments NR_SHMEM included tmpfs and GEM
pages whct is Gem pages
3-> is my above code analysis is correct?
