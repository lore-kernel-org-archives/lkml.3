Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaLSMXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:23:14 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36132 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaLSMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:23:13 -0500
MIME-Version: 1.0
From: Divya Vyas <edivya.vyas@gmail.com>
Date: Fri, 19 Dec 2014 17:52:52 +0530
Message-ID: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com>
Subject: Merge ftrace data of host and guest
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am adding trace data of host and guest using trace-merge script .

https://15351300108708232970.googlegroups.com/attach/66533d7b41eed0b/trace-merge.pl?part=0.1&view=1&vt=ANaJVrHKDEwmNeLGDINH0B5Ud4OIUrfQ2_2w2jo08nJujH7Oc9facKD3ckT2RbCiHkRAfnYxmZnBF7qi0SeMZr2IMsPBDNjgrYkblCRkmgSk2PryLVsGe5g

guest data

qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]

host data

comm-3826  [000] d...49836825726903: sched_wakeup: [detail]
comm-3826  [000] d...49836832225344: sched_switch: [detail]
~


Data after merging :

/opt/trace-merge/trace-merge 18446739773557710924 host.data guest.data

hcomm-3826  [000] d...49836825726903: sched_wakeup: [detail]
hcomm-3826  [000] d...49836832225344: sched_switch: [detail]
gqemu-kvm-2687  [003] d...54850231044361: kvm_exit: [detail]
gqemu-kvm-2687  [003] d...54850231047508: kvm_entry: [detail]
gqemu-kvm-2687  [003] d...54850231081348: kvm_exit: [detail]
gqemu-kvm-2687  [003] d...54850231084159: kvm_entry: [detail]
gqemu-kvm-2687  [003] d...54850231096795: kvm_exit: [detail]
gqemu-kvm-2687  [003] d...54850231109083: kvm_entry: [detail]
gqemu-kvm-2687  [003] d...54850231121521: kvm_exit: [detail]
gqemu-kvm-2687  [003] d...54850231126720: kvm_entry: [detail]

I think it is not desired output . Ths script is written for diffrent
format .ftrace format is ( trace-cmd report command generates) :

version = 6
CPU 0 is empty
cpus=2
          <idle>-0     [001]  4401.096833: netif_receive_skb:
dev=eth0 skbaddr=0xffff88001ed8fc00 len=84
          <idle>-0     [001]  4401.096899: net_dev_queue:
dev=eth0 skbaddr=0xffff88001a9fe000 len=98
          <idle>-0     [001]  4401.096935: net_dev_xmit:
dev=eth0 skbaddr=0xffff88001a9fe000 len=98 rc=0
          <idle>-0     [001]  4401.097277: netif_receive_skb:
dev=eth0 skbaddr=0xffff88001a9fe800 len=84
          <idle>-0     [001]  4401.097309: net_dev_queue:
dev=eth0 skbaddr=0xffff88001a9fea00 len=98
          <idle>-0     [001]  4401.097325: net_dev_xmit:
dev=eth0 skbaddr=0xffff88001a9fea00 len=98 rc=0
          <idle>-0     [001]  4401.097570: netif_receive_skb:
dev=eth0 skbaddr=0xffff88001a9fe800 len=84
          <idle>-0     [001]  4401.097592: net_dev_queue:
dev=eth0 skbaddr=0xffff88001a9fe000 len=98
          <idle>-0     [001]  4401.097607: net_dev_xmit:
dev=eth0 skbaddr=0xffff88001a9fe000 len=98 rc=0
          <idle>-0     [001]  4401.097830: netif_receive_skb:
dev=eth0 skbaddr=0xffff88001a9fe800 len=84
          <idle>-0     [001]  4401.097843: net_dev_queue:
dev=eth0 skbaddr=0xffff88001a9fea00 len=98


Can you let me know I there is any other method to merge the traces or
any further changes in the script
