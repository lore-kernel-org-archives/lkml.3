Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3CYCd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:33:59 -0400
Received: from mail-we0-f195.google.com ([74.125.82.195]:39738 "EHLO
	mail-we0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3CYCd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:33:58 -0400
MIME-Version: 1.0
Date: Mon, 25 Mar 2013 10:33:56 +0800
Message-ID: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
Subject: Question: How to distribute the interrupts over multiple cores?
From: Lenky Gao <lenky.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: yinghai@kernel.org, mingo@elte.hu, gorcunov@gmail.com,
        rusty@rustcorp.com.au, sivanich@sgi.com, agordeev@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I faced the same problem as this URL:
http://stackoverflow.com/questions/13641440/unable-to-distrubute-the-interrupts-over-multiple-cores

The question have been closed with no answer. :(

My machine have 2x Xeon E5504 processors and running vanilla kernel
3.6.11 in CentOS 6.0.

Could anyone give me some tips?

PS:
[root@localhost ~]# cat /proc/cmdline
ro root=/dev/mapper/vg_localhost-lv_root rd_NO_LUKS LANG=en_US.UTF-8
rd_NO_MD quiet rd_LVM_LV=vg_localhost/lv_swap
SYSFONT=latarcyrheb-sun16 rhgb rd_LVM_LV=vg_localhost/lv_root
KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM apic=debug pci=nomsi
[root@localhost ~]# uname -a
Linux localhost.lenkydomain 3.6.11 #2 SMP Fri Mar 22 21:13:41 CST 2013
x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# echo 6 > /proc/irq/25/smp_affinity
[root@localhost ~]# cat /proc/irq/25/smp_affinity
000006
[root@localhost ~]# cat /proc/interrupts | grep eth9
  25:       5824      13914        159        128        210
0          0          0  IR-IO-APIC-fasteoi   eth9
[root@localhost ~]# cat /proc/interrupts | grep eth9
  25:       5824      13927        159        128        210
0          0          0  IR-IO-APIC-fasteoi   eth9
[root@localhost ~]# cat /proc/interrupts | grep eth9
  25:       5824      13939        159        128        210
0          0          0  IR-IO-APIC-fasteoi   eth9
[root@localhost ~]# cat /proc/interrupts | grep eth9
  25:       5824      13973        159        128        210
0          0          0  IR-IO-APIC-fasteoi   eth9


-- 
Regards,

Lenky
