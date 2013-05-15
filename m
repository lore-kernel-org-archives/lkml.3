Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3EOMz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:55:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab3EOMz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:55:56 -0400
Message-ID: <1368622556.20549.13.camel@dcbw.foobar.com>
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken
 at times
From: Dan Williams <dcbw@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Causey <matt.causey@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.shmoo.com
Date: Wed, 15 May 2013 07:55:56 -0500
In-Reply-To: <20130515120801.GA24670@gamma.logic.tuwien.ac.at>
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
	 <CAGnc4p8w-Y8QHsEM_SbQLxFSfHC_X1ZCQpeKCXFJ8Qtk-cLHrA@mail.gmail.com>
	 <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
	 <518BC290.2040306@lwfinger.net>
	 <20130515120801.GA24670@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 21:08 +0900, Norbert Preining wrote:
> Hi everyone,
> 
> sorry for the late reply, business trip to Tokyo.
> 
> On Do, 09 Mai 2013, Larry Finger wrote:
> > absolutely critical, namely the PCI ID. There are at least three 
> 
> 10ec:8172
> 
> > I also recommend that you try either the wireless-testing git repo or the 
> > mainline git repo. There are a lot of changes that cannot be backported.
> 
> Ok, I will try.
> 
> On Fr, 10 Mai 2013, Matt Causey wrote:
> > Seems to indicate that the access point is ignoring your probe requests.
> > If that is happening for your client somehow, wpa_supplicant won't work
> > well.  :-)
> 
> I rebooted the rooter, after that it worked, for one day. After that
> agian problems.
> 
> Then I rebooted also linux and it works again.
> 
> > "NecAcces" - but I'm not familiar with that vendor.  Also, do you have a
> 
> Aterm WR8600N http://121ware.com/aterm/
> which is a NEC part, probably sold in other places under a different
> name. In Japan it is sold as this.
> 
> > WLAN packet capture (from another host nearby on the same channel)?  That
> > would be helpful as well.
> 
> Difficult, I only have an iPhone, and a wireless repeater for the TV,
> and I guess both are not enough for wlan sniffing.
> 
> In the meantime I have also tried wpa_supplicatn 2.0, without
> chagnes.
> 
> In the current log there are strange things:
> May 15 20:36:38 tofuschnitzel kernel: [78541.678861] wlan0: send auth to 00:3a
> :9d:b4:54:5a (try 1/3)
> May 15 20:36:38 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplican
> t interface state: scanning -> authenticating
> May 15 20:36:38 tofuschnitzel kernel: [78541.681046] wlan0: authenticated
> May 15 20:36:43 tofuschnitzel kernel: [78546.680713] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)

The deauth by local choice can often be NM terminating the connection
after a 20 second timeout, because if you haven't connected to the AP
within 20 seconds, you probably aren't going to.  Look above in the logs
for when NM actually tells the supplicant to connect.  Here's what the
entire association process looks like on my machine:

May 15 07:00:14 dcbw NetworkManager[20259]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
May 15 07:00:14 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: disconnected -> inactive
May 15 07:00:14 dcbw NetworkManager[20259]: <info> Config: set interface ap_scan to 1
May 15 07:00:14 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: inactive -> scanning
May 15 07:00:17 dcbw kernel: wlan0: authenticate with 00:13:aa:bb:cc:dd
May 15 07:00:17 dcbw kernel: wlan0: send auth to 00:13:aa:bb:cc:dd (try 1/3)
May 15 07:00:17 dcbw kernel: wlan0: authenticated
May 15 07:00:17 dcbw kernel: iwlwifi 0000:02:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
May 15 07:00:17 dcbw kernel: iwlwifi 0000:02:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
May 15 07:00:17 dcbw kernel: wlan0: associate with 00:13:aa:bb:cc:dd (try 1/3)
May 15 07:00:17 dcbw kernel: wlan0: RX AssocResp from 00:13:aa:bb:cc:dd (capab=0x411 status=0 aid=1)
May 15 07:00:17 dcbw kernel: wlan0: associated
May 15 07:00:17 dcbw kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
May 15 07:00:17 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: scanning -> authenticating
May 15 07:00:17 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: authenticating -> associating
May 15 07:00:17 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: associating -> 4-way handshake
May 15 07:00:17 dcbw NetworkManager[20259]: <info> (wlan0): supplicant interface state: 4-way handshake -> completed
May 15 07:00:17 dcbw NetworkManager[20259]: <info> Activation (wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless n

Here it's a total of 3 seconds between telling the supplicant "GO!" and
the supplicant completing the association.

Dan

> May 15 20:36:43 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
> May 15 20:36:44 tofuschnitzel NetworkManager[16128]: <info> (wlan0): supplicant interface state: disconnected -> scanning
> 
> Why does it go from authenticated -> directly to deauthenticating. Uffa.
> 
> Anyway, I will try some more things, esp wireless-testing.
> 
> Norbert
> 
> ------------------------------------------------------------------------
> PREINING, Norbert                               http://www.preining.info
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


