Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3EVI0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:26:15 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41793 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3EVI0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:26:09 -0400
Message-ID: <519C8141.4080706@suse.cz>
Date: Wed, 22 May 2013 10:26:41 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: iwlwifi: "fail to flush all tx fifo queues" and dies
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing $SUBJ from iwlwifi and then it stops working (ping has high
RTT etc.) with this device:
03:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N
6205 [Taylor Peak] [8086:0085] (rev 34)
        Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
[8086:1311]
        Flags: bus master, fast devsel, latency 0, IRQ 47
        Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 60-67-20-ff-ff-81-4a-dc
        Kernel driver in use: iwlwifi

When I disable 802.11n, it's gone:
modprobe iwlwifi 11n_disable=1

This is all with 3.9.3 kernel.

Dmesg output:
[90008.127440] cfg80211: Calling CRDA to update world regulatory domain
[90008.139827] cfg80211: World regulatory domain updated:
[90008.139832] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90008.139836] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90008.139839] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90008.139841] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90008.139844] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90008.139846] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90011.557669] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90011.560161] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90011.575100] wlan0: authenticated
[90011.575543] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[90011.592192] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[90011.600809] wlan0: associated
[90011.600968] cfg80211: Calling CRDA for country: GB
[90011.605228] cfg80211: Regulatory domain changed to country: GB
[90011.605233] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90011.605237] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90011.605239] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90011.605242] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90011.605244] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[90392.229463] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[90392.229472] iwlwifi 0000:03:00.0: Current SW read_ptr 110 write_ptr 247
[90392.229524] iwl data: 00000000: ff ff 3f 00 7f 00 00 00 00 80 ff ff
00 00 ff ff  ..?.............
[90392.229561] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[90392.229597] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b095
[90392.229633] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[90392.229670] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300045
[90392.229691] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[90392.229712] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[90392.229732] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[90392.229753] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709048
[90392.229832] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [70,70]
[90392.229909] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[90392.229987] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [249,249]
[90392.230065] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[90392.230149] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[90392.230227] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[90392.230305] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[90392.230388] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[90392.230521] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[90392.230671] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [73,73]
[90392.230750] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[90392.230827] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [111,247]
[90392.230977] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231063] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231144] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231274] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231360] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231473] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231558] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90392.231644] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90453.413842] cfg80211: Calling CRDA to update world regulatory domain
[90453.437671] cfg80211: World regulatory domain updated:
[90453.437677] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90453.437681] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90453.437684] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90453.437686] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90453.437689] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90453.437691] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90456.774117] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90456.776360] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90456.806109] wlan0: authenticated
[90456.807005] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[90456.811076] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[90456.822785] wlan0: associated
[90456.822926] cfg80211: Calling CRDA for country: GB
[90456.827857] cfg80211: Regulatory domain changed to country: GB
[90456.827863] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90456.827866] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90456.827869] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90456.827871] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90456.827873] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[90512.524765] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[90512.524773] iwlwifi 0000:03:00.0: Current SW read_ptr 152 write_ptr 197
[90512.524832] iwl data: 00000000: 00 00 00 ff 00 00 00 06 ff 1f 00 00
70 00 00 00  ............p...
[90512.524869] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[90512.524905] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b0ac
[90512.524926] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[90512.524962] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030004f
[90512.524983] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[90512.525019] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[90512.525039] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[90512.525077] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090ee
[90512.525155] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [80,80]
[90512.525238] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[90512.525316] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [111,111]
[90512.525394] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[90512.525477] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[90512.525554] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[90512.525632] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[90512.525758] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[90512.525858] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[90512.525940] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [239,239]
[90512.526026] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[90512.526159] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [152,197]
[90512.526244] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526333] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526479] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526613] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526705] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526788] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526874] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90512.526960] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[90594.515989] cfg80211: Calling CRDA to update world regulatory domain
[90594.519436] cfg80211: World regulatory domain updated:
[90594.519441] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90594.519445] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90594.519448] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90594.519450] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90594.519453] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90594.519455] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90597.872693] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90597.875212] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90597.904896] wlan0: authenticated
[90597.905995] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[90597.910076] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[90597.921771] wlan0: associated
[90597.921927] cfg80211: Calling CRDA for country: GB
[90597.926595] cfg80211: Regulatory domain changed to country: GB
[90597.926601] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90597.926604] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90597.926607] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90597.926609] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90597.926612] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[90609.517742] cfg80211: Calling CRDA to update world regulatory domain
[90609.521309] cfg80211: World regulatory domain updated:
[90609.521315] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90609.521318] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90609.521321] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90609.521324] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90609.521326] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90609.521329] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90612.899852] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90612.901797] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90612.920586] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 2/3)
[90613.049972] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 3/3)
[90613.076487] wlan0: authentication with 14:d6:4d:cd:4b:2e timed out
[90624.697553] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90624.700463] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90624.702980] wlan0: authenticated
[90624.703661] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[90624.707630] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[90624.717199] wlan0: associated
[90624.717348] cfg80211: Calling CRDA for country: GB
[90624.721716] cfg80211: Regulatory domain changed to country: GB
[90624.721722] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90624.721725] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90624.721728] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90624.721730] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90624.721732] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[90850.680850] cfg80211: Calling CRDA to update world regulatory domain
[90850.684666] cfg80211: World regulatory domain updated:
[90850.684673] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90850.684678] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90850.684682] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90850.684685] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[90850.684689] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90850.684693] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[90862.212040] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[90862.214551] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[90862.229579] wlan0: authenticated
[90862.230261] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[90862.235878] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[90862.246734] wlan0: associated
[90862.246840] cfg80211: Calling CRDA for country: GB
[90862.250583] cfg80211: Regulatory domain changed to country: GB
[90862.250588] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[90862.250591] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90862.250594] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90862.250596] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[90862.250598] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[91591.588372] cfg80211: Calling CRDA to update world regulatory domain
[91591.593238] cfg80211: World regulatory domain updated:
[91591.593244] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[91591.593248] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[91591.593251] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[91591.593253] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[91591.593256] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[91591.593258] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[91594.981072] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[91594.982153] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[91595.012490] wlan0: authenticated
[91595.013275] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[91595.017262] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[91595.022920] wlan0: associated
[91595.023009] cfg80211: Calling CRDA for country: GB
[91595.026693] cfg80211: Regulatory domain changed to country: GB
[91595.026699] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[91595.026702] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[91595.026705] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[91595.026707] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[91595.026709] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[92038.663037] cfg80211: Calling CRDA to update world regulatory domain
[92038.667064] cfg80211: World regulatory domain updated:
[92038.667069] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92038.667072] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92038.667075] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92038.667078] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92038.667080] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92038.667083] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92042.045356] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[92042.047968] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[92042.063278] wlan0: authenticated
[92042.064013] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[92042.068090] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[92042.080991] wlan0: associated
[92042.081147] cfg80211: Calling CRDA for country: GB
[92042.085524] cfg80211: Regulatory domain changed to country: GB
[92042.085529] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92042.085532] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92042.085535] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92042.085537] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92042.085539] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[92146.538148] cfg80211: Calling CRDA to update world regulatory domain
[92146.542591] cfg80211: World regulatory domain updated:
[92146.542597] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92146.542600] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92146.542603] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92146.542606] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92146.542608] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92146.542610] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92149.923675] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[92149.925907] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[92149.943355] wlan0: authenticated
[92149.944073] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[92149.948101] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[92149.953587] wlan0: associated
[92149.953698] cfg80211: Calling CRDA for country: GB
[92149.957582] cfg80211: Regulatory domain changed to country: GB
[92149.957586] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92149.957589] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92149.957591] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92149.957594] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92149.957596] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[92314.007270] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[92314.007280] iwlwifi 0000:03:00.0: Current SW read_ptr 141 write_ptr 169
[92314.007331] iwl data: 00000000: 00 e0 ff ff 00 00 e0 3f 7f 00 00 00
20 00 00 00  .......?.... ...
[92314.007374] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[92314.007410] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b0a6
[92314.007446] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[92314.007484] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000a3
[92314.007520] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[92314.007556] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[92314.007593] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[92314.007629] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090ac
[92314.007709] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [164,164]
[92314.007787] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[92314.007865] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [88,89]
[92314.007942] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[92314.008026] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[92314.008104] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[92314.008181] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[92314.008305] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[92314.008393] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[92314.008474] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [173,173]
[92314.008554] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[92314.008638] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [141,169]
[92314.008717] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.008804] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.008891] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.008977] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.009061] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.009150] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.009276] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92314.009355] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92552.018285] cfg80211: Calling CRDA to update world regulatory domain
[92552.022175] cfg80211: World regulatory domain updated:
[92552.022181] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92552.022184] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92552.022187] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92552.022190] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92552.022192] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92552.022194] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92555.425322] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[92555.426590] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[92555.444113] wlan0: authenticated
[92555.445369] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[92555.449251] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[92555.457598] wlan0: associated
[92555.457689] cfg80211: Calling CRDA for country: GB
[92555.461527] cfg80211: Regulatory domain changed to country: GB
[92555.461533] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92555.461536] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92555.461539] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92555.461541] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92555.461543] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[92915.901967] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[92915.901975] iwlwifi 0000:03:00.0: Current SW read_ptr 80 write_ptr 175
[92915.902026] iwl data: 00000000: 00 00 ff ff 00 00 fe 7f ff 3f 00 00
00 00 00 00  .........?......
[92915.902062] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[92915.902098] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b06d
[92915.902134] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[92915.902155] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000b1
[92915.902191] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[92915.902228] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[92915.902248] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[92915.902269] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x0070902c
[92915.902354] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [178,178]
[92915.902430] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[92915.902508] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [202,202]
[92915.902592] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[92915.902679] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[92915.902757] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[92915.902840] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[92915.902918] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[92915.903045] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[92915.903128] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [45,45]
[92915.903212] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[92915.903290] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [80,175]
[92915.903367] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903428] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903496] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903557] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903627] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903703] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903765] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92915.903826] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[92983.267661] cfg80211: Calling CRDA to update world regulatory domain
[92983.272243] cfg80211: World regulatory domain updated:
[92983.272248] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92983.272252] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92983.272255] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92983.272257] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[92983.272260] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92983.272262] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[92986.643194] wlan0: authenticate with 14:d6:4d:cd:4b:2e
[92986.645444] wlan0: send auth to 14:d6:4d:cd:4b:2e (try 1/3)
[92986.662913] wlan0: authenticated
[92986.663630] wlan0: associate with 14:d6:4d:cd:4b:2e (try 1/3)
[92986.667538] wlan0: RX AssocResp from 14:d6:4d:cd:4b:2e (capab=0xc11
status=0 aid=1)
[92986.683920] wlan0: associated
[92986.684009] cfg80211: Calling CRDA for country: GB
[92986.687250] cfg80211: Regulatory domain changed to country: GB
[92986.687255] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[92986.687258] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92986.687260] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92986.687262] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[92986.687264] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[93027.091295] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
[93027.091303] iwlwifi 0000:03:00.0: Current SW read_ptr 115 write_ptr 169
[93027.091368] iwl data: 00000000: 07 00 00 00 00 00 00 00 00 00 f8 ff
00 00 00 00  ................
[93027.091404] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[93027.091440] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x80102082
[93027.091467] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[93027.091488] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000bb
[93027.091524] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[93027.091545] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[93027.091578] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[93027.091615] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x0070908c
[93027.091685] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [188,188]
[93027.091762] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93027.091853] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [115,169]
[93027.091937] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93027.092021] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93027.092099] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93027.092183] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93027.092310] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93027.092398] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93027.092475] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [141,141]
[93027.092554] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93027.092637] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo
1 ra_tid 0x0000 [198,198]
[93027.092698] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.092765] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.092915] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.092977] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.093033] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.093097] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.093183] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93027.093295] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.163708] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
[93155.163717] iwlwifi 0000:03:00.0: Current SW read_ptr 244 write_ptr 250
[93155.163776] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 30 00
00 00 00 00  ..........0.....
[93155.163818] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[93155.163856] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b01d
[93155.163901] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[93155.163946] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000c3
[93155.163982] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[93155.164025] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[93155.164045] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[93155.164066] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x0070905a
[93155.164151] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [196,196]
[93155.164228] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93155.164312] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [244,250]
[93155.164397] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93155.164474] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93155.164558] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93155.164636] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93155.164759] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93155.164845] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93155.164935] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [91,91]
[93155.165013] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93155.165091] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [16,49]
[93155.165175] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165253] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165321] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165382] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165443] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165526] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165588] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93155.165650] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.405979] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[93501.405988] iwlwifi 0000:03:00.0: Current SW read_ptr 204 write_ptr 208
[93501.406044] iwl data: 00000000: 00 f0 00 00 00 00 00 00 00 00 00 00
00 00 00 00  ................
[93501.406081] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[93501.406118] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b0cf
[93501.406154] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[93501.406191] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000db
[93501.406227] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[93501.406263] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[93501.406300] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[93501.406337] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709023
[93501.406416] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [220,220]
[93501.406493] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93501.406576] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [243,243]
[93501.406659] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93501.406749] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93501.406827] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93501.406940] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93501.407034] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93501.407118] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93501.407206] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [36,36]
[93501.407287] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93501.407371] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [204,208]
[93501.407454] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407545] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407625] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407710] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407796] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407877] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.407991] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93501.408074] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.411241] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
[93503.411248] iwlwifi 0000:03:00.0: Current SW read_ptr 206 write_ptr 213
[93503.411298] iwl data: 00000000: 00 c0 1f 00 00 00 00 00 00 00 00 00
00 00 00 00  ................
[93503.411335] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[93503.411372] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x801020f4
[93503.411408] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[93503.411445] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000dc
[93503.411484] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[93503.411522] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[93503.411560] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[93503.411599] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709024
[93503.411681] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [221,221]
[93503.411766] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93503.411858] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [243,245]
[93503.411939] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93503.412032] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93503.412109] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93503.412187] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93503.412311] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93503.412390] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93503.412468] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [37,37]
[93503.412546] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93503.412613] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [206,213]
[93503.412675] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.412753] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.412836] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.412900] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.412985] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.413121] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.413198] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93503.413287] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.405217] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
[93506.405225] iwlwifi 0000:03:00.0: Current SW read_ptr 244 write_ptr 245
[93506.405275] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 10 00
00 00 00 00  ................
[93506.405311] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[93506.405347] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b0d9
[93506.405383] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[93506.405420] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x803000dd
[93506.405456] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[93506.405493] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[93506.405529] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[93506.405566] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709029
[93506.405652] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [222,222]
[93506.405729] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93506.405813] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [244,245]
[93506.405891] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93506.405983] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[93506.406062] iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93506.406140] iwlwifi 0000:03:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[93506.406259] iwlwifi 0000:03:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93506.406350] iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[93506.406438] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [42,42]
[93506.406544] iwlwifi 0000:03:00.0: Q 10 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[93506.406629] iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1
ra_tid 0x0000 [206,218]
[93506.406711] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.406795] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.406899] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.407038] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.407117] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.407220] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.407320] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]
[93506.407409] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo
0 ra_tid 0x0000 [0,0]


Reloaded with 802.11n disabled:

[93527.356994] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[93527.357000] Copyright(c) 2003-2013 Intel Corporation
[93527.357871] iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
[93527.363704] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
[93527.369717] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[93527.369724] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[93527.369727] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[93527.369730] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[93527.369733] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[93527.369737] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6205 AGN, REV=0xB0
[93527.369790] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[93527.385882] ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
[93527.454628] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[93527.461431] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[93527.832913] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[93527.839654] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
...

Any ideas?

thanks,
-- 
js
suse labs
