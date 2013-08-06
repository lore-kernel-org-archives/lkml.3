Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3HFOqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:46:10 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45067 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3HFOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:46:08 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1375797260.8219.21.camel@jlt4.sipsolutions.net>
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	<1375797260.8219.21.camel@jlt4.sipsolutions.net>
Date: Tue, 6 Aug 2013 16:46:06 +0200
Message-ID: <CA+icZUUAJ25QybqHvxz7eubSLH6YuNjcc5zyU2O5Xi9vevMGkw@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-08-06 at 15:51 +0200, Sedat Dilek wrote:
>> OK, I did not try with debugging enabled and/or w/o Network-Manager.
>>
>> If you know of an issue, please let me know.
>
> No, but the dmesg looks like security problems - check wpa_supplicant
> log
>

I start a debug-session like this:

# stop network-manager
# kill -9 $(pidof wpa_supplicant)
# /sbin/wpa_supplicant -B -P /run/sendsigs.omit.d/wpasupplicant.pid -u
-s -O /var/run/wpa_supplicant -t -ddd
# start network-manager
# tail -f /var/log/syslog

# egrep 'warn|fail|error' /root/syslog_for-johill.txt
Aug  6 16:29:00 fambox wpa_supplicant[1150]: wlan0: WPA: 4-Way
Handshake failed - pre-shared key may be incorrect
Aug  6 16:29:07 fambox wpa_supplicant[1150]: wlan0: WPA: 4-Way
Handshake failed - pre-shared key may be incorrect
Aug  6 16:29:13 fambox NetworkManager[1064]: <warn> quit request
received, terminating...
Aug  6 16:30:21 fambox NetworkManager[2541]: <warn> (wlan0): driver
supports Access Point (AP) mode
Aug  6 16:30:21 fambox NetworkManager[2541]: <warn> failed to allocate
link cache: (-10) Operation not supported
Aug  6 16:30:21 fambox NetworkManager[2541]: <warn> Trying to remove a
non-existant call id.
Aug  6 16:30:21 fambox wpa_supplicant[2533]: nl80211: Scan trigger
failed: ret=-16 (Device or resource busy)
Aug  6 16:30:27 fambox wpa_supplicant[2533]: EAPOL: External
notification - EAP fail=0
Aug  6 16:30:34 fambox wpa_supplicant[2533]: EAPOL: External
notification - EAP fail=0
Aug  6 16:30:42 fambox wpa_supplicant[2533]: EAPOL: External
notification - EAP fail=0
Aug  6 16:30:48 fambox wpa_supplicant[2533]: EAPOL: External
notification - EAP fail=0
Aug  6 16:31:04 fambox NetworkManager[2541]: <warn> quit request
received, terminating...

I send you the full syslog.txt to your sipsolutions email-address (not
sure if it contains sensitive data).

- Sedat -

> johannes
>
