Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3COPnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:43:17 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:41964 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3COPnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:43:15 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH]Skip unnecessary WARN_ON in panic case
Thread-Topic: [PATCH]Skip unnecessary WARN_ON in panic case
Thread-Index: Ac4anDzq+rG7ySZjS3KQDJuvdM1EoADt7+6AAM8YOUA=
Date: Fri, 15 Mar 2013 15:39:30 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF699D7@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF5CB8B@USINDEM103.corp.hds.com>
 <20130311082851.GC12742@gmail.com>
In-Reply-To: <20130311082851.GC12742@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-03-15_06:2013-03-15,2013-03-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=inbound_policy_notspam policy=inbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1303150102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for giving me the feedback.

> 
> So it appears the problem occurs because the other CPUs are not offlined correctly, and still have pending work which may generate
> wakeup IPIs to them?

Right.

> 
> The fix would be to either offline them properly - or, if we don't want to do that to keep panicking simple, why do we mark them
> offline? They aren't really offline in a proper way.

To offline cpus properly, it should be done with threads like stop_machine().
But I don't think it is reasonable to kick the threads in panic case.
Therefore, I will make a patch keeping cpus online.
Also, to inform a panicked cpu that other cpus stopped surely,
 I will  introduce a new cpu_mask like cpu_stopped_mask.

Seiji
