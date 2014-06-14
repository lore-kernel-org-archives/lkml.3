Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaFNPNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:13:19 -0400
Received: from ns.horizon.com ([71.41.210.147]:49375 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754711AbaFNPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:13:17 -0400
Date: 14 Jun 2014 11:13:14 -0400
Message-ID: <20140614151314.2721.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614111405.9630.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, my test suite is not particularly lightweight.
Here are some figures (idle at full speed, and doing a parallel
kernel compile) for a 2.5 GHz Phenom.

Quite different numbers compared to the Ivy Bridge.  When the processor is
bust, fast_mix takes longer, instead.  And even the rolled up fast_mix2 is
(slightly) faster than the original fast_mix.  The 64-bit code is basically
the same speed as the 2x unrolled 32-bit code.

Presented in the same strange order as the Ivy Bridge, even though it's
not fastest-to-slowest this time.


Rolled up, 3x:
30748 5432	49066 24126
30583 6526	50271 23788
28621 4541	52966 25610
28017 3425	54181 25733
30425 5213	54441 25878
28556 3895	48969 26499
27853 3057	50813 25431
27471 2396	54065 27685
30328 5053	55931 27500
28702 3821	50811 24877

Unrolled, 3x:
26785 4278	40386 12695
25617 3302	41349 16593
25154 2357	41166 15904
24816 1886	40571 17449
27537 4927	41716 15723
28128 6657	42085 18098
25640 3410	41453 16486
25087 2199	39964 12193
27750 5384	38960 13672
26584 4699	38280 13697

Original:
35291 10362	82640 37663
32043 7848	81887 44853
32968 8994	80527 44847
31087 7207	84894 47535
29904 5602	81426 45401
34312 9824	54889 29060
36471 12948	65112 34232
31622 8539	63531 33871
31570 7745	57946 29070
30074 6116	62829 34393

Unrolled, 2x:
24491 2411	40335 16992
27644 6721	38981 16068
25473 4347	35260 10750
24784 3372	34211 10360
24326 2689	34178 11200
26404 4896	34498 10483
24905 3517	33793 10409
24107 2150	35321 11330
23968 1903	33818 11301
26254 4671	32728 9547

64-bit:
26877 7949	52258 25946
24862 5940	55765 27634
24528 5032	56568 28142
24844 5223	55007 27671
27115 8018	55754 27873
25504 6504	54286 27471
24772 5673	52717 26609
24427 4889	51362 27109
27219 8276	51431 22619
25640 6718	52835 26329
