Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbaISSPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:15:09 -0400
Received: from www.sr71.net ([198.145.64.142]:54873 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbaISSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:15:07 -0400
Message-ID: <541C72A9.9090509@sr71.net>
Date: Fri, 19 Sep 2014 11:15:05 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org, hpa@linux.intel.com,
        brice.goglin@gmail.com, bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
References: <20140918193334.C065EBCE@viggo.jf.intel.com> <20140919114529.GD5366@x2.net.home>
In-Reply-To: <20140919114529.GD5366@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 04:45 AM, Karel Zak wrote:
>  hmm... it would be also nice to test it with lscpu(1) from 
>  util-linux (but it uses maps rather than lists from cpu*/topology/).

Here's the output with and with out Cluster-on-Die enabled.

Everything looks OK to me.  The cache size changes are what the CPU
actually tells us through CPUID leaves.

[root@otc-grantley-03 ~]# diff -ru lscpu.nocod lscpu.wcod
--- lscpu.nocod	2014-09-19 04:01:17.846336595 -0700
+++ lscpu.wcod	2014-09-19 04:10:56.557383761 -0700
@@ -6,18 +6,20 @@
 Thread(s) per core:    2
 Core(s) per socket:    18
 Socket(s):             2
-NUMA node(s):          2
+NUMA node(s):          4
 Vendor ID:             GenuineIntel
 CPU family:            6
 Model:                 63
 Model name:            Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz
 Stepping:              2
-CPU MHz:               1340.468
-BogoMIPS:              4590.53
+CPU MHz:               1360.234
+BogoMIPS:              4590.67
 Virtualization:        VT-x
 L1d cache:             32K
 L1i cache:             32K
 L2 cache:              256K
-L3 cache:              46080K
-NUMA node0 CPU(s):     0-17,36-53
-NUMA node1 CPU(s):     18-35,54-71
+L3 cache:              23040K
+NUMA node0 CPU(s):     0-8,36-44
+NUMA node1 CPU(s):     9-17,45-53
+NUMA node2 CPU(s):     18-26,54-62
+NUMA node3 CPU(s):     27-35,63-71


