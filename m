Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3ENP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:29:21 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38042 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3ENP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:29:18 -0400
Message-ID: <5192584C.1060003@lwfinger.net>
Date: Tue, 14 May 2013 10:29:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel 3.10-rc1 build warning on 32-bit ppc associated with commit
 3925f46
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When building 3.10-rc1 on a PowerBook G4, I get the following warning:

cc1: warnings being treated as errors
arch/powerpc/perf/core-book3s.c: In function ‘power_pmu_bhrb_read’:
arch/powerpc/perf/core-book3s.c:1479: error: integer constant is too large for 
‘long’ type
make[2]: *** [arch/powerpc/perf/core-book3s.o] Error 1
make[1]: *** [arch/powerpc/perf] Error 2
make[1]: *** Waiting for unfinished jobs....
   LD      arch/powerpc/platforms/powermac/built-in.o
   LD      arch/powerpc/platforms/built-in.o
make[1]: Leaving directory `/home/finger/wireless-testing'
make: *** [debian/stamp/build/kernel] Error 2

The code in question came from commit 3925f46 entitled "powerpc/perf: Enable 
branch stack sampling framework". The gcc version is 4.4.5 running with a Mint 9 
distribution.

I have disabled the "-Werror" switch so that the build can continue. That 
Kconfig question about disabling WERROR is a bit confusing with its double 
negative construction.

Thanks,

Larry
