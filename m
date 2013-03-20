Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3CTUma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:42:30 -0400
Received: from nm22.access.bullet.mail.mud.yahoo.com ([66.94.237.223]:23115
	"EHLO nm22.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430Ab3CTUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:42:29 -0400
X-Yahoo-Newman-Id: 779148.69914.bm@smtp103.rog.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1gFgTeAVM1m2.pwC2XeFdOgMac09z3aD.h5D4buyBzSN0s4
 OMp.nTVpfP0Dg9O9MCTaxmQ9eLcSduqFfmu1nSM5fSaVCLvxuBJ0b6seH.62
 ccVaXgGPbQbtFVf1VGeO_Ulps5Xcq4XmkSPo__mlDGhkwFUvPf3rqKQWzDVW
 Ea9SD4eFy3_9g5jc8xDZ7UE2hTYb9Sk8q9zg0qfmwuCVIzlGIQvky8F79Pdd
 J3LrtkrdZ1p3J.USVUY_wzJFivElYtBfKH9JIZC8fZns9sNTS.wtkrAghGWK
 crm6f9sMuEdnRtXLG0Uog7yy9lce4GwBhmnpepQDjtQwr9poqesAIhylC5h9
 MH8_k7QCsMDZm2dXP_BttNJWElCwoqYFcbg1rflhj8rF.IiINOcPXm9Y2bPQ
 cU2IdNU.vW1WjjlwZjpl4uCATWBWoJwlHSEbhCDJOEkl0jxL0BGmKzsd0VGt
 oUvtFyDi.39zgJhM1OSBcXHFk3Kvu6_Hm6hQQILW.49BOqrgP0U3NcEXl.Ni
 J.8KQU8yZaSZTF1930tAHaYez0C5aPgGQhiagp_Ajf7wi_RtLvsnWDKS7nPo
 sM8A6QXB5
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-Rocket-Received: from segfault.sh0n.net (shawn.starr@99.237.244.34 with plain)
        by smtp103.rog.mail.bf1.yahoo.com with SMTP; 20 Mar 2013 13:42:28 -0700 PDT
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [Intel][RNG] PCI IDs commented out for 82801I (ICH9 Mobile and non-mobile)?
Date: Wed, 20 Mar 2013 16:42:22 -0400
Message-ID: <1597390.RUFC41Uyje@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.5 (Linux/3.8.0-2.fc19.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I was looking at why I can't load the Intel RNG driver (or why it doesn't load automatically) and 
it just so happens I have both the mobile and non-mobile ICH9 chipset. Looking at the driver I noticed:

 /* BAM, CAM, DBM, FBM, GxM
       { PCI_DEVICE(0x8086, 0x2448) }, */
 
 /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
       { PCI_DEVICE(0x8086, 0x244e) }, */

IDs from both machines:
 
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
 
I saw a thread from 2006 explaining the 50% chance there's no RNG (but these days all modern chipsets should have an RNG) and I know 
this chipset I have does have an RNG so I'd like to use the HW random generator vs software.

Do we need to revisit this? Even if I try to force it to load it still fails:

# modprobe intel_rng no_fwh_detect=-1 or =1 
modprobe: ERROR: could not insert 'intel_rng': No such device

Thanks,
Shawn
