Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaLVPwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:52:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaLVPwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:52:02 -0500
Message-ID: <54983E8F.5060500@oracle.com>
Date: Mon, 22 Dec 2014 10:53:51 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: xen-devel <xen-devel@lists.xenproject.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Testing preemptibility test in xen_setup_cpu_clockevents()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 250a1ac685f (x86, smpboot: Remove pointless preempt_disable() in 
native_smp_prepare_cpus()) HVM guests no longer boot since we are 
hitting BUG_ON(preemptible()) in xen_setup_cpu_clockevents().

I don't think we need this test (PV or HVM), do we?


-boris
