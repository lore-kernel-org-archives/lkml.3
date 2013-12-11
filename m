Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3LKMJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:09:23 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39950 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3LKMJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:09:22 -0500
MIME-Version: 1.0
Date: Wed, 11 Dec 2013 14:01:29 +0200
Message-ID: <CA+Mediw7p6CEHAvP0p=MdCQmWL10QASVpxTo-_WDsvFgxziyww@mail.gmail.com>
Subject: [3.10.22+][3.12][performance regression] - huge softirq increase on netfilter
From: Nikolay Ulyanitsky <lystor@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello


3.10.22 has new 2 patches that increase softirq from 0.0% to 15.0% in
comparison with 3.10.21 on my software routers:

78ab8cb      netfilter: nf_conntrack: use RCU safe kfree for conntrack
extensions
873be93      ipc/sem.c: synchronize semop and semctl with IPC_RMID


Screenshots:
Server1 (ipt_NETFLOW):     http://s12.postimg.org/5eprc03tp/vega.png
Server2 (NAT):    http://s27.postimg.org/swj3he8dv/mimosa.png


Server1:
3.10.21: softirq = 0%
3.10.22+, 3.12.4: softirq = 15%
3.10.22+, 3.12.4 WITHOUT 78ab8cb, WITH 873be93: softirq = 1%
3.10.22+, 3.12.4 WITHOUT 78ab8cb, WITHOUT 873be93: softirq = 0%


Hardware:
2 x Xeon 3.2GHz, Intel SE7520, 4 x Intel 82576 Gigabit Network

CentOS 6.5 x86_64


Kernel configs:
3.12.4: http://pastebin.com/ugTWFeJg
3.10.22: http://pastebin.com/N8z4UAV5


Please fix/revert these patches.


Thanks


–

With best regards,

Nikolay Ulyanitsky
