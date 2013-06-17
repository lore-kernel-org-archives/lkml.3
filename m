Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3FQT7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:59:25 -0400
Received: from sam.nabble.com ([216.139.236.26]:36415 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3FQT7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:59:23 -0400
Date: Mon, 17 Jun 2013 12:58:53 -0700 (PDT)
From: ghostrain <605033747@qq.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1371499133126-668877.post@n7.nabble.com>
Subject: Cannot switch between 20MHz and 40MHz rates
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there! Thanks for your attention!!

I have 1 STA and 1 AP (hostapd + wireless-compat ath9k driver). What I am
trying to do is:

1.AP starts with HT20 (I did this through commenting out any ht_capab lines
in hostapd.conf)

2.STA connects to AP (so STA is also HT20)

3.STA issues an action frame to AP, AP sends back another action frame as
ACK and changes its tx bitrates to HT40

what I do for changing tx bitrates now is setting ht_cap flag and update
rate table, i.e. in function ieee80211_rx_h_action() in file
net/mac80211/rx.c, on receiving my action frame for rate update, do:

    rx->sta->sta.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40; 
    rate_control_rate_update();

4.STA receives ACK and do something (what I do now is update its rate table
as I do on AP side).

[b]The problem is[/b]: when AP starts with HT40+ and STA connects,
transmission first uses HT40 rates and then switches to HT20 rates on
issuing my action frame. But when AP starts with HT20 and STA connects,
transmission can only use HT20 rates: once switched to HT40 rates,
transmission will pause, until switching back to HT20.

Could anybody give me some hints on possible reasons, please? Is this a
hostapd configuration problem? or I am doing wrong updating rates? or it is
theoretically impossible to using HT40 rates if started with HT20?

Thanks!!



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/Cannot-switch-between-20MHz-and-40MHz-rates-tp668877.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
