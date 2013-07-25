Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3GYIDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:03:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56646 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3GYIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:03:20 -0400
Message-ID: <51F0DB11.2080508@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 13:30:17 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Hack bench regression with CONFIG_SLUB_CPU_PARTIAL disabled (info
 only)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072507-5490-0000-0000-000003E2061C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing hackbench with 3.11-rc1 I observed hackbench testcase
took too long to complete (32 vcpu kvm guest on 32 core HT off machine).

hackbench 1x degraded by 3 time (40sec vs 112sec)
hackbench 2x degraded by around 20time (90sec vs 1800 sec)

When I bisected, I found that I had CONFIG_SLUB_CPU_PARTIAL
accidentally disabled.
I understand that  CONFIG_SLUB_CPU_PARTIAL=y by default and the config
option is to provide determinism for RT kernels and thus it is not a
problem.
But thought of sharing this here so that if somebody runs into same 
issue accidently, it would save their time.

