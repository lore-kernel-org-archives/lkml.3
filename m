Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab3JWFlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:41:45 -0400
Received: from services.gouders.net ([141.101.32.176]:48622 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3JWFln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:41:43 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG bisected] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
In-Reply-To: <201310222200.55773.sw@simonwunderlich.de> (Simon Wunderlich's
	message of "Tue, 22 Oct 2013 22:00:55 +0200")
References: <gifvruyge3.fsf@karga.hank.lab>
	<20131022132303.GA14762@pandem0nium> <ghzjq1pcc3.fsf@lena.gouders.net>
	<201310222200.55773.sw@simonwunderlich.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Wed, 23 Oct 2013 07:41:54 +0200
Message-ID: <ghvc0opmql.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

Simon Wunderlich <sw@simonwunderlich.de> writes:

> Hey Dirk,
>
>> No need for censorship, I did some quick tests and stripped down my
>> wpa_supplicant.conf to a single entry.  With this configuration I get a
>> lot of traces:
>> 
>> ctrl_interface=/var/run/wpa_supplicant
>> eapol_version=1
>> ap_scan=1
>> fast_reauth=1
>> 
>> network={
>> 	frequency=2412
>> 	group=TKIP
>> 	key_mgmt=NONE
>> 	mode=1
>> 	pairwise=NONE
>> 	ssid="Nokia_n9"
>> }
>> 
>> I will also attach a dmesg output of my tests.
>> 
>> >  * your wpa_supplicant command line parameters when running
>> 
>> It is running with a wpa_cli like this:
>> 
>> /usr/sbin/wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf \
>>     -W -B -i wlp4s0 -P /var/run/wpa_supplicant-wlp4s0.pid
>> /usr/bin/wpa_cli -a /etc/wpa_supplicant/wpa_cli.sh \
>>     -p /var/run/wpa_supplicant -i wlp4s0 -P /var/run/wpa_cli-wlp4s0.pid -B
>> 
>
> Thanks a lot for this, I could reproduce the issue and fix it, will send the fix 
> in a minute - please try and report back. 

thanks a lot, will send my test result immediately.

> Just two notes on your setup in case you are interested:

Yes, I am interested - I was just afraid to ask, because I didn't want
to cause too much noise with probably trivial problems ;-)

>  * Your wpa-supplicant setup looks a little like an old WPA-NONE setup, but 
> this is not supported anymore and will not encrypt your messages. Please have 
> a look at IBSS/RSN if you want encryption.

Yes, I very rarely use that connection and always have in mind that it
is unencrypted.  I will have a look at this but expect the mobile phone
side to be the hard one to get it to offer reliable encryption.

>  * Your wpa_supplicant uses the old wext interface to the kernel. This is 
> deprecated, it would better to use the (not so) new nl80211 interface instead. 
> You will also get goodies such as 802.11n rates in ad-hoc mode if your 
> hardware supports it. :)

Thats good to know, I will change my setup accordingly.

Thanks again for your help,

Dirk

> Thanks again for reporting,
>    Simon
