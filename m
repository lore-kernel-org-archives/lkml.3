Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3HSVfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:35:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3HSVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:35:46 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iKlYmpTFJ6IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_-yd4YAFh8UA:10 a=0G-pJu9H_6PBYHEStYQA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819213324.405942342@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 17:33:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 0/3] hwlat-detector: Have it actually find hardware latency
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thi patch series fixes up hwlat-detector to check the entire path
of time for a latency being hit, instead of the quick check between
two time stamps.

It also uses the trace_local_clock() if available, which is much lighter
weight than ktime_get() which might produce false positives. As
the trace clock is used to detect irq latencies, it's suitable for
hardware latency.

Finally, stop machine is removed and the test is run by a single thread.

