Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3D0FIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:08:24 -0400
Received: from smtprelay0056.b.hostedemail.com ([64.98.42.56]:38051 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752257Ab3D0FIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:08:22 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Apr 2013 01:08:22 EDT
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::,RULES_HIT:152:355:379:582:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3421:3622:3865:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4361:5007:6261:9025:9108:10004:10400:10471:10848:11473:11658:11914:12043:12438:12517:12519:12555:12698:12737:13069:13071:13091:13161:13229:13255:13311:13357:13548,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cough85_6ab05c28faf10
X-Filterd-Recvd-Size: 1640
Date: Sat, 27 Apr 2013 04:58:53 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Cc: dirk.j.brandewie@intel.com, rjw@sisk.pl, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Message-ID: <475427035.74642.1367038733183.JavaMail.mail@webmail08>
Subject: CONFIG_X86_INTEL_PSTATE disables CPU frequency transition stats,
 many governors and other standard features
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.201.215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just wanted to let everyone know that CONFIG_X86_INTEL_PSTATE wreaks
havoc with the CPU frequency subsystem in the Linux kernel.

With this option enabled:

1) All governors except performance and powersave are gone, ondemand
userspace, conservative

2) scaling_cur_freq is gone, thus user space utilities monitoring the CPU
frequency have stopped working

3) CPU frequency transition stats are gone, there's no "stats" directory
anywhere

4) scaling_available_frequencies is gone, so I cannot set the desired constant
CPU frequency (the userspace governor is not available anyway)

Is this an intended behavior? I shrivel to think that's the case.

The bug report is filed here: https://bugzilla.kernel.org/show_bug.cgi?id=57141

Best regards,

Artem
