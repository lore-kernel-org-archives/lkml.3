Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3F0Opk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:45:40 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46173 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0Opi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:45:38 -0400
Message-ID: <51CC500C.9050602@lwfinger.net>
Date: Thu, 27 Jun 2013 09:45:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Brent-Crosby <brent@crystalfontz.com>, Jim Wall <jimwall@q.com>,
        Thomas Petazzoni <thomas@free-electrons.com>
Subject: Re: RTL8192CU on ARM not working
References: <20130627081225.GJ5803@lukather>
In-Reply-To: <20130627081225.GJ5803@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:12 AM, Maxime Ripard wrote:
> Hi everyone,
>
> I'm currently trying to use a RTL8192CU on an ARM (Freescale imx28,
> armv5) platform, using 3.10-rc3.
>
> Trouble is, while the chip is correctly detected and you can use iw on it
> without any problem it seems, once you start an association to an access
> point, the association goes on, seems to associate, displaying a WARN()
> message [1] and then, after what looks like a random amount of time (could
> be right away, could be after a few minutes), deassociate [2].
>
> During the time where it's associated, we never seem to transmit any
> packets, while iw reports packets being sent, I guess we can assume that
> they are actually never transmitted as well [3].
>
> What seems odd to me as well is that the signal power reported for the access
> point is excessively high when using iw scan (10 dbm), and once connected, the
> signal strength is -64dbm, which makes quite a huge difference.

That warning is under discussion. See the thread entitled "rtl8192cu: slow path 
warning" in the linux-wireless ML. I will add you to the Cc list on those messages.

You should switch to kernel 3.10-rc7. There are a lot of changes to rtl8192cu in 
that version that are not in -rc3. Those updates mostly affect WPA and WEP 
encryption.

I never take signal power values seriously. Just observe the comments scattered 
throughout the code regarding them.

Larry

