Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3KGKye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:54:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53034 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3KGKyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:54:31 -0500
MIME-Version: 1.0
Date: Thu, 7 Nov 2013 11:54:30 +0100
Message-ID: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
Subject: Bench for testing scheduler
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Alex Shi <alex.shi@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, rjw@rjwysocki.net,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Paul Walmsley <paul@pwsan.com>, Mel Gorman <mgorman@suse.de>,
        Juri Lelli <juri.lelli@gmail.com>, fengguang.wu@intel.com,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        Kevin Hilman <khilman@linaro.org>, Frank.Rowand@sonymobile.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During the Energy-aware scheduling mini-summit, we spoke about benches
that should be used to evaluate the modifications of the scheduler.
I’d like to propose a bench that uses cyclictest to measure the wake
up latency and the power consumption. The goal of this bench is to
exercise the scheduler with various sleeping period and get the
average wakeup latency. The range of the sleeping period must cover
all residency times of the idle state table of the platform. I have
run such tests on a tc2 platform with the packing tasks patchset.
I have use the following command:
#cyclictest -t <number of cores> -q -e 10000000 -i <500-12000> -d 150 -l 2000

The figures below give the average wakeup latency and power
consumption for default scheduler behavior, packing tasks at cluster
level and packing tasks at core level. We can see both wakeup latency
and power consumption variation. The detailed result is not a simple
single value which makes comparison not so easy but the average of all
measurements should give us a usable “score”.

I know that Ingo would like to add the benches in Tools/* but I wonder
if it make sense to copy cyclictest in this directory when we have an
official git tree here:
git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

I have put both final "score" and detailed results below so everybody
can check the score vs detailed figures:

            |  Default average results                  |  Cluster
Packing average results          |  Core Packing average results
            |  Latency     stddev  A7 energy A15 energy |  Latency
stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15
energy
            |     (us)                   (J)        (J) |     (us)
              (J)        (J) |     (us)                   (J)
(J)
            |      879                794890    2364175 |      416
           879688      12750 |      189                897452
30052

 Cyclictest |  Default                                  |  Packing at
Cluster level                 |  Packing at Core level
   Interval |  Latency     stddev  A7 energy A15 energy |  Latency
stddev  A7 energy A15 energy |  Latency     stddev  A7 energy A15
energy
       (us) |     (us)                   (J)        (J) |     (us)
              (J)        (J) |     (us)                   (J)
(J)
        500         24          1    1147477    2479576         21
     1    1136768      11693         22          1    1126062
30138
        700         22          1    1136084    3058419         21
     0    1125280      11761         21          1    1109950
23503
        900         22          1    1136017    3036768         21
     1    1112542      12017         20          0    1101089
23733
       1100         24          1    1132964    2506132         21
     0    1109039      12248         21          1    1091832
23621
       1300         24          1    1123896    2488459         21
     0    1099308      12015         21          1    1086301
23264
       1500         24          1    1120842    2488272         21
     0    1099811      12685         20          0    1083658
22499
       1700         41         38    1117166    3042091         21
     0    1090920      12393         21          1    1080387
23015
       1900        119        182    1120552    2737555         21
     0    1087900      11900         21          1    1078711
23177
       2100        167        195    1122425    3210655         22
     2    1090420      11900         20          1    1077985
22639
       2300        152        156    1119854    2497773         43
    22    1087278      11921         21          1    1075943
26282
       2500        182        163    1120818    2365870         63
    29    1089169      11551         21          0    1073717
24290
       2700        439        202    1058952    3058516        107
    41    1077955      12122         21          0    1070951
23126
       2900        570        268    1028238    3099162        148
    30    1067562      13287         24          1    1064200
24260
       3100        751        137     946512    3158095        178
    30    1059395      12236         29          1    1058887
23225
       3300        696        203     964822    3042524        206
    28    1041194      13934         36          1    1056656
23941
       3500        728        191     959398    3006066        235
    36    1028150      13387         44          3    1045841
23873
       3700        844        138     921780    3033189        245
    31    1019065      14582         62          6    1034466
22501
       3900        815        172     925600    2862994        273
    33    1001974      12091         80          9    1014650
24444
       4100        870        179     897616    2940444        279
    35     996226      12014         88         11    1030588
25461
       4300        979        119     846912    2996911        306
    36     980075      12641        100         12    1035173
24832
       4500        891        168     863631    2760879        336
    45     955072      12016        126         12     993256
23929
       4700        943        110     836333    2796629        351
    39     942390      12902        125         15     996548
24637
       4900        997        118     800205    2743317        391
    49     917067      12868        134         23    1011089
25266
       5100       1050        114     789152    2693104        408
    53     903123      12033        196         22     894294
25142
       5300       1052        111     769544    2668315        425
    54     895006      12264        171         19     933356
25873
       5500       1002        179     794222    2554432        430
    45     886025      12007        171         18     938921
24382
       5700       1002        180     786714    2441228        436
    46     878043      12258        172         14     944908
30291
       5900       1117         90     742883    2554813        471
    53     864134      12471        170         12     957811
25119
       6100       1166         92     734510    2566381        479
    68     854384      12579        190         16     926807
25544
       6300       1132        123     738812    2447974        488
    57     849740      12968        216         10     882940
26546
       6500       1123        150     743870    2323338        495
    52     836256      12472        210         20     896639
25149
       6700       1173        139     724691    2330720        522
    70     822678      12949        269         27     800938
28653
       6900       1054        112     725451    2953919        522
    69     822682      12184        261         26     785269
28199
       7100       1098        174     731504    2255090        502
    87     820909      13072        216         15     870777
25336
       7300       1244        156     702596    2317562        531
    88     808677      12770        247         18     813081
28126
       7500       1181        143     694538    2226994        545
    90     796698      12368        226         14     862177
26597
       7700       1189        147     681836    2183167        555
    87     799215      12499        250         17     797699
26342
       7900       1082        149     694010    1926757        555
    90     791777      13137        243         20     824061
26772
       8100       1068        145     678222    2791019        552
    80     785043      13071        266         16     781563
26579
       8300       1102        135     690978    1851892        582
   136     781035      13067        267         18     782060
26683
       8500       1190        191     653566    2068057        574
   127     777348      13139        262         21     800524
27086
       8700       1172        185     666525    2031543        602
   104     778754      13364        228         13     884802
25340
       8900       1024        179     685123    1689661        594
    98     768617      13753        266         20     801557
26075
       9100       1077        166     658295    1756367        615
   101     759656      13297        308         19     739619
25677
       9300       1211        203     618593    2055230        606
   111     753652      13231        319         23     743849
26041
       9500       1163        189     627123    1794459        615
   125     751993      13174        264         19     865898
25795
       9700       1240        202     589520    1983417        649
   157     738596      13473        326         71     742113
25528
       9900       1188        207     612908    1830208        635
   125     725890      14240        299         40     770069
24714
      10100       1168        219     596998    1781611        647
   132     718260      13834        245         35     905581
24854
      10300       1083        222     615543    1506529        641
   130     700636      13108        401         24     643222
26497
      10500       1183        210     573875    1753476        648
   169     708408      12756        392         30     636559
28712
      10700       1217        234     526025    2014191        648
   165     696542      13092        374         26     675566
28555
      10900       1161        179     594406    1722260        647
   194     698681      13715        344         45     682158
26681
      11100       1185        209     578309    1919206        670
   166     724562      13408        339         50     743402
28010
      11300       1144        185     609694    1791436        671
   136     712555      12769        307         36     762260
26575
      11500       1070        188     617941    1470628        650
   151     723367      12596        353         21     659704
28015
      11700       1205        199     570787    1801593        673
   168     706260      12568        347         12     689414
29196
      11900       1216        174     563915    1761745        686
   135     698164      12840        361         10     663126
27517
      12100       1155        218     568867    1596189        677
   159     705873      12759        309         14     774833
290747
      12300       1236        187     543536    1738447        705
   177     705564      13028        330         21     745009
28134
      12500       1176        202     545135    1651420        696
   148     697624      13280        339         20     724057
26461

Vincent
