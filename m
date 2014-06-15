Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaFOJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 05:07:32 -0400
Received: from ns.horizon.com ([71.41.210.147]:58401 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750845AbaFOJHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 05:07:31 -0400
Date: 15 Jun 2014 05:07:29 -0400
Message-ID: <20140615090729.12350.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, linux@horizon.com, tytso@mit.edu
Subject: Re: Surprising 64-bit performance anomaly (was Re: [PATCH] random: use an improved fast_mix() function)
In-Reply-To: <20140615031913.GB8111@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is just *weird*.  I'm testing on bare metal, and I keep measuring
significantly better performance for the 64-bit code.  Here's an i7-2700K
@ 3.50GHz.  (I added a "rolled x2" measurement just for interest's sake.)

The idle performance is very similar for the original and unrolled x2
versions, but under load the original degrades far more. (174.5 cycles
vs. 132.1 for fast_mix3.)

And the 64-bit code is less than 2/3 the time of the 32-bit code
under load. (84.3 cycles average = 132.1 * 63.8%)


Idle		make -j9

Rolled x3:
27043 1212	62897 28037
26910 1547	58415 25790
27095 1302	59158 26083
30684 6233	37242 15848
26979 1339	59683 24658
27042 1534	61609 27537
27069 1402	56379 25877
27301 1162	56782 26379
27300 1535	55344 25003
26873 1507	48627 22207

Rolled x2:
25697 2859	34779 11771
27097 5065	31805 12125
25564 2646	54448 22853
25123 2191	57469 29098
24931 2106	57621 27855
25223 2207	63852 31484
24956 2112	74393 34080
25889 2340	65434 33316
25170 2031	68246 31109
25541 2296	70891 34294

Unrolled x3:
23066 1358	50698 29156
22990 1569	59566 28935
22797 1269	58363 28813
22321 1004	54652 30148
23122 1545	52651 29113
22704 875	57904 33033
22793 979	51882 28880
22413 891	55537 30635
22814 997	52760 27188
22998 1020	59592 30133

Original:
22038 2303	26656 18045
21209 2082	37559 22256
21134 1626	40082 23261
20689 1436	34227 19133
20804 1503	48391 28563
20979 1617	48235 28095
20752 1427	52101 29817
21046 1830	56703 30179
20828 1362	51196 28658
20865 1659	51641 29680

Unrolled x2:
21051 1667	29000 17989
20889 1381	28328 16046
21244 1664	33015 21364
21130 1628	32588 21417
20753 1497	42376 25412
21943 2917	39879 24932
20880 1279	24064 15512
21303 1389	38724 24107
21416 1712	36570 23549
20956 1652	33578 22983

64-bit, unrolled x2:
16037 1031	16651 9740
16664 2094	19199 12689
16129 1057	20216 8590
16211 905	18382 9964
16637 2056	20125 8495
16229 1218	24190 13176
16515 1632	28717 18022
16220 1096	23762 13147
16307 1103	19599 5382
16326 1145	24844 12837
