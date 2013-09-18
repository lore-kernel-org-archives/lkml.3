Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3IRILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:11:37 -0400
Received: from forward10.mail.yandex.net ([77.88.61.49]:57020 "EHLO
	forward10.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3IRILf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:11:35 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 04:11:35 EDT
From: DimanNe <dimanne@ya.ru>
Envelope-From: Dimanne@yandex.ru
To: linux-kernel@vger.kernel.org
Subject: nfs mount fails on startup
MIME-Version: 1.0
Message-Id: <342091379491489@web28m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 18 Sep 2013 12:04:49 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

After updating to Kubuntu 13.10 beta (kernel version is 3.11.0-7-generic) my nfs share stopped auto-mounting during boot.

Here is my fstab:
dimanne@Impedance:~$ cat /etc/fstab
# <file system>                           <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda1 during installation
UUID=328a9124-e5ff-4c13-a7e2-559ee6a20292 /               ext4    errors=remount-ro 0       1
# swap was on /dev/sda5 during installation
UUID=b3a4a4a4-c563-45c1-9d6b-602b07d66c70 none            swap    sw              0       0
# was on /dev/sdb1
UUID=9383ee42-aea8-4098-9533-08d1b9b04e59 /mnt/backup    ext4   defaults        0       2
# was on /dev/sdc1
UUID=4ad4e84a-1e0e-4cb6-a63a-753d3ffc9ff2 /mnt/freedata ext4    defaults        0       2

server:/mnt/media                       /mnt/media      nfs4    defaults


Also I noticed suspicious messages in dmesg:
dimanne@Impedance:~$ dmesg | grep killed
[   23.436063] init: idmapd-mounting (/mnt/media) main process (455) killed by TERM signal
[   26.828198] init: failsafe main process (1119) killed by TERM signal
[   28.352642] init: kdm main process (1757) killed by TERM signal

However if I mount nfs share manually (sudo mount -vvv server:/mnt/media /mnt/media) all works perfectly, but at this time I get these messages in dmesg
[  458.804009] NFS: Registering the id_resolver key type
[  458.804024] Key type id_resolver registered
[  458.804026] Key type id_legacy registered
[  473.827828] RPC: AUTH_GSS upcall timed out.
[  473.827828] Please check user daemon is running.


What is the problem, how can I fix it?
