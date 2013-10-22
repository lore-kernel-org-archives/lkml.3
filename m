Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3JVUL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:11:59 -0400
Received: from packetmixer.de ([83.151.30.3]:38338 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3JVUL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:11:58 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2013 16:11:58 EDT
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Dirk Gouders <dirk@gouders.net>
Subject: Re: [BUG bisected] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
Date: Tue, 22 Oct 2013 22:00:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <gifvruyge3.fsf@karga.hank.lab> <20131022132303.GA14762@pandem0nium> <ghzjq1pcc3.fsf@lena.gouders.net>
In-Reply-To: <ghzjq1pcc3.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201310222200.55773.sw@simonwunderlich.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dirk,

> No need for censorship, I did some quick tests and stripped down my
> wpa_supplicant.conf to a single entry.  With this configuration I get a
> lot of traces:
> 
> ctrl_interface=/var/run/wpa_supplicant
> eapol_version=1
> ap_scan=1
> fast_reauth=1
> 
> network={
> 	frequency=2412
> 	group=TKIP
> 	key_mgmt=NONE
> 	mode=1
> 	pairwise=NONE
> 	ssid="Nokia_n9"
> }
> 
> I will also attach a dmesg output of my tests.
> 
> >  * your wpa_supplicant command line parameters when running
> 
> It is running with a wpa_cli like this:
> 
> /usr/sbin/wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf \
>     -W -B -i wlp4s0 -P /var/run/wpa_supplicant-wlp4s0.pid
> /usr/bin/wpa_cli -a /etc/wpa_supplicant/wpa_cli.sh \
>     -p /var/run/wpa_supplicant -i wlp4s0 -P /var/run/wpa_cli-wlp4s0.pid -B
> 

Thanks a lot for this, I could reproduce the issue and fix it, will send the fix 
in a minute - please try and report back. 

Just two notes on your setup in case you are interested:

 * Your wpa-supplicant setup looks a little like an old WPA-NONE setup, but 
this is not supported anymore and will not encrypt your messages. Please have 
a look at IBSS/RSN if you want encryption.
 * Your wpa_supplicant uses the old wext interface to the kernel. This is 
deprecated, it would better to use the (not so) new nl80211 interface instead. 
You will also get goodies such as 802.11n rates in ad-hoc mode if your 
hardware supports it. :)

Thanks again for reporting,
   Simon
