Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3GZLmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:42:45 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11730 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3GZLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:42:44 -0400
Message-ID: <51F260AF.7010409@hp.com>
Date: Fri, 26 Jul 2013 19:42:39 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cpw@sgi.com,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>, Jingbai Ma <jingbai.ma@hp.com>,
        "Wang, Jin (Steven)" <jin.wang@hp.com>
Subject: makedumpfile 1.5.4 + kernel 3.11-rc2+ 4TB tests
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have run some tests with makedumpfile 1.5.4 and upstream kernel 
3.11-rc2+ on a machine with 4TB memory, here is testing results:

Test environment:
Machine: HP ProLiant DL980 G7 with 4TB RAM.
CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores)
(Only 1 CPU was enabled the 2nd kernel)
Kernel: 3.11.0-rc2+ (at patch b3a3a9c441e2c8f6b6760de9331023a7906a4ac6)
crashkernel=384MB
vmcore size: 4.0TB
Dump file size: 15GB
All measured time from debug message of makedumpfile.
As a comparison, I also have tested makedumpfile 1.5.3.

(all time in seconds)
                      Excluding pages   Copy data   Total
makedumpfile 1.5.3          468         1182       1650
makedumpfile 1.5.4           93          518        611


So it seems there is a great performance improvement by the mmap mechanism.

--
Thanks,
Jingbai Ma
