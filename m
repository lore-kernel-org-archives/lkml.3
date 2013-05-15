Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3EOHPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:15:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51727 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3EOHPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:15:05 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-08-519335f52c75
Date: Wed, 15 May 2013 07:15:01 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Question about ext4 excessive stall time
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>, jack@suse.cz, dmonakhov@openvz.org,
        gnehzuil.liu@gmail.com
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130515063606250@eunb.song
Msgkey: 20130515063606250@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130515063606250@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26998592.95551368602101253.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zpu5X08mBBmeXWFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mth0BBXfcK64d3sfYwPjGtYuRk0NIQEWi5f93xi5GDg4JAROJ
	g7dkQMISAmISF+6tZ+ti5AIqWcYosfr5InaIhInE8lObGCES8xklLu+YBpZgEVCV2H5wLyuI
	zSagLfH2ywMwW1jAUOLu+UMsILaIgK3Ek58bmECamQW2MkqcX3SFHeIKeYnJpy+D2bwCghIn
	Zz5hgbhISaL5pRFEWFli+RmQXpAjJCRmTb/ACmHzSsxof8oCYctJTPu6hhnClpY4P2sDI8w3
	i78/horzSxy7vYMJYjyvxJP7wTBjdm/+wgZhC0hMPXMQqlVd4mrnTKg4n8SahW9ZYMbsOrWc
	Gab3/pa5YKcxCyhKTOl+yA5ha0l8+bGPDdVXILajxLa9T9knMCrPQpKahaR9FpJ2ZDULGFlW
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoQkhd4djLcPWB9iTAZGyURmKdHkfGBSySuJNzQ2
	M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY4K616eJyuZb
	Xjhps9tWTUvfqnVaSvzgzE1Xpp5fMPPpnB/PGvuNeU6kv81M7inoCH5WeenvBfW7OW/3mVZc
	iOJUcXrs9uZoq3XkoQapjrhbbqLzcvJntW34E+q2a6flz2NsXytsyvLKHlnd/GWuUdh793tm
	oU2T8rkrRSIPbz9bxnlIYcNMRSWW4oxEQy3mouJEAByHiWcgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN2vppMDDTafMLe4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GW07AgruuFdcO7yPsYHxjWsXIyeHkICKRMv/74wgtoSAicTyU5ugbDGJC/fWs3UxcgHVzGeU
	uLxjGjtIgkVAVWL7wb2sIDabgLbE2y8PwGxhAUOJu+cPsYDYIgK2Ek9+bmACaWYW2MoocX7R
	FXaIbfISk09fBrN5BQQlTs58AtTAAbRNSaL5pRFEWFli+RmQXpAjJCRmTb/ACmHzSsxof8oC
	YctJTPu6hhnClpY4P2sD3NGLvz+GivNLHLu9gwliPK/Ek/vBMGN2b/7CBmELSEw9cxCqVV3i
	audMqDifxJqFb1lgxuw6tZwZpvf+lrlgpzELKEpM6X7IDmFrSXz5sY8N1VcgtqPEtr1P2Scw
	ys1CkpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXGOkVJ+YWl+al6yXn525iBCeoZ4t2MP47b32I
	UYCDUYmHN0J2cqAQa2JZcWXuIUYJDmYlEV5dQ6AQb0piZVVqUX58UWlOavEhxmRgBE5klhJN
	zgcmz7ySeENjA2NDQ0tzA1NDIwvShJXEeZ+1WgcKCaQnlqRmp6YWpBbBbGHi4JRqYBTrfLdJ
	Qt6UxYV/7ds7/0T41swNb943U/XLruh52fJHP4ilJh5KeLN429qFl09W74tsPb5ALLp6lpqg
	+7cXhTcSe0ROXftptu6o6hp9S37f70U8yyIdPn1Wa92R+0vqX5W18pzwO3PO2Jhoq7jd2/2X
	efoXrRS9W5xXpXWuVwsYfS1WvcJwzEmJpTgj0VCLuag4EQCzx7C1lAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4F7FG5A012694


Hello. 
I saw some commit messages about excessive stall times in ext4. 
The same problem was reproduced in my board. Actually, i'm not sure that is the same problem.
But the calltrace message is very similar with commit id: f783f091. 

My board configuration as follow.
Linux: 2.6.32.60
CPU: 8CPU
Disk: SSD
File system: ext4

I know my kernel version is so old. I just want to know why this problem is happened.
Because of my kernel version is old? or Because of disk ?,,
If anyone knows about this problem, Could you help me?

As i said,  the calltrace message is very similar with commit id: f783f091 as below.
Because i enabled hungtask detection and set the hungtask timeout to 120 seconds. 
the calltrace messages were printed by this. 

[  262.455615] INFO: task swm:1692 blocked for more than 120 seconds.
[  262.461715] Stack : 0000000000000000 ffffffff8011f684 0000000000000000 a8000001f8b33960
[  262.469438]         a8000001f7f2ce38 00000000ffffb6a9 0000000000000005 ffffffff80efa270
[  262.477424]         a8000001f7f2d0e8 0000000000000020 0000000000000000 ffffffff80ec69a0
[  262.485732]         00000001f90a3a50 a800000107c93020 a8000001f9062eb8 a8000001f9302950
[  262.493708]         a8000001f5121280 a8000001f90a3810 a8000001f7e20000 0000000000000000
[  262.501675]         0000000000000004 a800000107c93020 a8000001f8b339c0 ffffffff8011cd50
[  262.509661]         a8000001f9062eb8 ffffffff8011f684 0000000000000001 ffffffff8011cea8
[  262.517647]         a8000001f9302950 ffffffff804295a0 a8000001f9302950 0000001800000000
[  262.525652]         0000000000000000 a8000001f7f2ce38 ffffffff802e3f00 a8000001f4f73bb8
[  262.533631]         a800000107c93038 ffffffff8043987c 0000000000000000 a8000001f9302950
[  262.541603]         ...
[  262.544208] Call Trace:
[  262.546668] [<ffffffff8011c598>] __schedule_nobkl+0x278/0x900
[  262.552391] [<ffffffff8011cd50>] __schedule+0x48/0x80
[  262.557431] [<ffffffff8011cea8>] schedule+0x10/0x28
[  262.562269] [<ffffffff804295a0>] do_get_write_access+0x470/0x6a8
[  262.568285] [<ffffffff80434620>] jbd2_journal_get_write_access+0x30/0x58
[  262.574939] [<ffffffff804171a8>] __ext4_journal_get_write_access+0x48/0x88
[  262.581817] [<ffffffff803fc0f8>] ext4_reserve_inode_write+0x80/0xa8
[  262.588056] [<ffffffff803fc174>] ext4_mark_inode_dirty+0x54/0x1e8
[  262.594121] [<ffffffff803fc4a0>] ext4_dirty_inode+0x38/0x70
[  262.599745] [<ffffffff80381a98>] __mark_inode_dirty+0x40/0x228
[  262.605493] [<ffffffff803747bc>] file_update_time+0xec/0x190
[  262.611159] [<ffffffff8031cb20>] __generic_file_aio_write+0x1f8/0x3e8
[  262.617568] [<ffffffff8031cd70>] generic_file_aio_write+0x60/0xc0
[  262.623636] [<ffffffff8035c1f4>] do_sync_write+0xbc/0x120
[  262.629037] [<ffffffff8035ce24>] vfs_write+0xb4/0x178
[  262.634049] [<ffffffff8035cfd0>] SyS_write+0x48/0xa0
[  262.639022] [<ffffffff80102fc4>] handle_sys64+0x44/0x60
[  262.644221] 
262.645734] INFO: task evm:1814 blocked for more than 120 seconds.
[  262.651855] Stack : 0000000000000000 a8000001f442b930 0000000000000000 0000000000100100
[  262.659651]         a8000001f44fc5b8 00000000ffffb4e6 0000000000000000 ffffffff80efa270
[  262.667637]         a8000001f44fc868 0000000000000001 0000000000000000 ffffffff80ec69a0
[  262.675643]         a8000001f5da63a0 a800000107ca2020 a8000001f9214438 a8000001f5da63a0
[  262.683608]         a8000001f5121280 a8000001f90a3798 a8000001f7e20000 0000000000000000
[  262.691594]         0000000000000004 a800000107ca2020 a8000001f442ba70 ffffffff8011cd50
[  262.699579]         a8000001f9214438 ffffffff8011f684 0000000000000001 ffffffff8011cea8
[  262.707565]         a8000001f5da63a0 ffffffff804295a0 a8000001f5da63a0 0000001800000000
[  262.715576]         0000000000000000 a8000001f44fc5b8 ffffffff802e3f00 a800000107ca2038
[  262.723536]         a800000107ca2038 ffffffff8043987c 0000000000000000 a8000001f5da63a0
[  262.731522]         ...
[  262.734126] Call Trace:
[  262.736578] [<ffffffff8011c598>] __schedule_nobkl+0x278/0x900
[  262.742312] [<ffffffff8011cd50>] __schedule+0x48/0x80
[  262.747373] [<ffffffff8011cea8>] schedule+0x10/0x28
[  262.752185] [<ffffffff804295a0>] do_get_write_access+0x470/0x6a8
[  262.758220] [<ffffffff80434620>] jbd2_journal_get_write_access+0x30/0x58
[  262.764857] [<ffffffff804171a8>] __ext4_journal_get_write_access+0x48/0x88
[  262.771738] [<ffffffff803f94f0>] ext4_new_inode+0x290/0x1298
[  262.777367] [<ffffffff80406c40>] ext4_create+0xe8/0x1e0
[  262.782566] [<ffffffff80367c58>] vfs_create+0xf8/0x180
[  262.787705] [<ffffffff8036bcc8>] do_filp_open+0xab0/0xbb0
[  262.793069] [<ffffffff8035a060>] do_sys_open+0x78/0x170
[  262.798293] [<ffffffff80102fc4>] handle_sys64+0x44/0x60
[  262.803480] 

[  262.804984] INFO: task logrotate:2422 blocked for more than 120 seconds.
[  262.811674] Stack : 0000000000000000 0000000000000000 0000000000000000 ffffffff8040ebb8
[  262.819451]         a8000001f46b6738 00000000ffffafaf 0000000000000000 ffffffff80efa270
[  262.827436]         a8000001f46b69e8 0000000000000001 0000000000000000 ffffffff80ec69a0
[  262.835421]         ffffffff80ec6d48 a800000107c93020 a8000001f9062eb8 a8000001f9302950
[  262.843407]         a8000001f5121280 a8000001f90a3bb8 a8000001f7e20000 0000000000000000
[  262.851393]         0000000000000004 a800000107c93020 a8000001f4f73ba0 ffffffff8011cd50
[  262.859378]         a8000001f9062eb8 ffffffff8011f684 0000000000000001 ffffffff8011cea8
[  262.867364]         a8000001f9302950 ffffffff804295a0 a8000001f9302950 0000001800000000
[  262.875349]         0000000000000000 a8000001f46b6738 ffffffff802e3f00 a800000107c93038
[  262.883335]         a8000001f8b339d8 ffffffff8043987c 0000000000000000 a8000001f9302950
[  262.891321]         ...
[  262.893925] Call Trace:
[  262.896380] [<ffffffff8011c598>] __schedule_nobkl+0x278/0x900
[  262.902089] [<ffffffff8011cd50>] __schedule+0x48/0x80
[  262.907143] [<ffffffff8011cea8>] schedule+0x10/0x28
[  262.911985] [<ffffffff804295a0>] do_get_write_access+0x470/0x6a8
[  262.917994] [<ffffffff80434620>] jbd2_journal_get_write_access+0x30/0x58
[  262.924655] [<ffffffff804171a8>] __ext4_journal_get_write_access+0x48/0x88
[  262.931534] [<ffffffff803fc0f8>] ext4_reserve_inode_write+0x80/0xa8
[  262.937775] [<ffffffff804075c8>] ext4_orphan_add+0x130/0x298
[  262.943405] [<ffffffff804027a4>] ext4_setattr+0x1bc/0x3e0
[  262.948806] [<ffffffff80376f74>] notify_change+0x1a4/0x3a0
[  262.954255] [<ffffffff8035b140>] do_truncate+0x58/0xa8
[  262.959397] [<ffffffff8035b9cc>] SyS_ftruncate+0x104/0x160
[  262.964845] [<ffffffff80102fc4>] handle_sys64+0x44/0x60Thanks.

Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
