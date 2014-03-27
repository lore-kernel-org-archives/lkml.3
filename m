Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaC0LER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:04:17 -0400
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:36034 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbaC0LEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:04:15 -0400
X-Greylist: delayed 6739 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2014 07:04:15 EDT
From: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Hiroshi Baba <h-baba@ax.jp.nec.com>
Subject: fail to add 64 VLANs or more when SR-IOV is enabled
Thread-Topic: fail to add 64 VLANs or more when SR-IOV is enabled
Thread-Index: Ac9JlO1ffB0oi4AYSwyNh+nra3OjGQ==
Date: Thu, 27 Mar 2014 09:10:32 +0000
Message-ID: <9DE5760509B7974286F38D93BF31DD62C7CAA1@BPXM13GP.gisp.nec.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.8.69]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


We're facing an issue that we cannot add 64 VLANs or more per VF.
When using SR-IOV, pass through a VF to the KVM guest and a lot of VLANs,
we could add 63 VLANs using vconfig but we failed to add 64th VLAN.
We'd like to use many VLANs on the guest with SR-IOV.
We're using Intel's 82599EB chip with ixgbe and ixgbevf driver.

Has anyone seen the same issue?
Is there any idea to solve this?

The below instruction is a reproducing method.
Create hundred VLANs on the guest.

# for i in `seq 100 199`; do vconfig add eth2 $i; ifconfig 192.168.$i.1/24; done

# vconfig add eth2 100
Added VLAN with VID == 100 to IF -:eth2:-

# vconfig add eth2 101
Added VLAN with VID == 101 to IF -:eth2:-

# vconfig add eth2 102
Added VLAN with VID == 102 to IF -:eth2:-

...

# vconfig add eth2 162
Added VLAN with VID == 162 to IF -:eth2:-

# vconfig add eth2 163
ERROR: trying to add VLAN #163 to IF -:eth2:-  error: Permission denied
SIOCSIFADDR: No such device
eth2.163: unknown interface: No such device

# vconfig add eth2 164
ERROR: trying to add VLAN #164 to IF -:eth2:-  error: Permission denied
SIOCSIFADDR: No such device
eth2.164: unknown interface: No such device

# vconfig add eth2 165
ERROR: trying to add VLAN #165 to IF -:eth2:-  error: Permission denied
SIOCSIFADDR: No such device
eth2.165: unknown interface: No such device


thanks,
Madoka Komatsubara
