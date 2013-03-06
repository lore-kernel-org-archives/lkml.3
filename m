Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3CFKHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:07:37 -0500
Received: from mx0.aculab.com ([213.249.233.131]:35805 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752942Ab3CFKHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:07:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH BUGFIX 2/6] pkt_sched: fix the update of eligible-group sets
Date: Wed, 6 Mar 2013 10:05:58 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7178@saturn3.aculab.com>
In-Reply-To: <1362506702-4985-3-git-send-email-paolo.valente@unimore.it>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH BUGFIX 2/6] pkt_sched: fix the update of eligible-group sets
Thread-Index: Ac4ZzDE3/jvM4TiFRgqaMVHfgBInfAAhccsw
References: <20130226.173700.882998504986475149.davem@davemloft.net> <1362506702-4985-1-git-send-email-paolo.valente@unimore.it> <1362506702-4985-3-git-send-email-paolo.valente@unimore.it>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Paolo valente" <paolo.valente@unimore.it>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, <shemminger@vyatta.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fchecconi@gmail.com>, <rizzo@iet.unipi.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Between two invocations of make_eligible, the system virtual time may
> happen to grow enough that, in its binary representation, a bit with
> higher order than 31 flips. This happens especially with
> TSO/GSO. Before this fix, the mask used in make_eligible was computed
> as (1UL<<index_of_last_flipped_bit)-1, whose value is well defined on
> a 64-bit architecture, because index_of_flipped_bit <= 63, but is in
> general undefined on a 32-bit architecture if index_of_flipped_bit > 31.
> The fix just replaces 1UL with 1ULL.
...
> -		unsigned long mask = (1UL << fls(vslot ^ old_vslot)) - 1;
> +		unsigned long mask = (1ULL << fls(vslot ^ old_vslot)) - 1;

I'm not sure you really want to be doing 64bit shifts on 32 bit
systems just to generate ~0ul.
probably worth a conditional.

	David


