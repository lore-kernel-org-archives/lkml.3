Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3FCK0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:26:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3FCK0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:26:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Date: Mon, 03 Jun 2013 12:26:49 +0200
Message-ID: <1822564.TIKVDZSzqK@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306031146.57611.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de> <9452845.qTGjLPCfXq@wuerfel> <201306031146.57611.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:fqehXXVrDPjK4v0wN0YSyWAJa0smfkP6mZC4om7tFio
 MdWlWjsKKWdnFqfgse6F8sa+VoIAkBNZEca4VhZnAItR2TNNan
 qq0fAAy4Tp2wgl96K3f+E+qRZp48+D2xC843t/QneqnEp3bMmL
 i3vcQ6LL0kf3ZGufH9WIhuN/oprlIPcWidAZpsXFM0QMts5Teo
 90j/+m75q6zsUNJE5R+8MkVD7quk9ZGeCcbmVsYZc7DtrnkqlK
 4OmhPFDaDi70+lRC8ZAuO08Ai05uYiQRrhFso0hKmbvIPox3K6
 8gNKmKX+MB6QBhmwyLkHQpERJuePNCpJ5curJzG7Om+lokaeSg
 /24mgzG6iksLNlqZrzDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 11:46:57 Heiko Stübner wrote:
> 
> The timers are of the same type and the clocksource driver just grabs the 
> first of them as clockevent and the second as clocksource, so I think two 
> CLOCKSOURCE_OF_DECLARE lines won't do.

Ok, got it. I was confused by the fact that the existing two sets of
"compatible" strings have separate sets of strings:

static const struct of_device_id sptimer_ids[] __initconst = {
        { .compatible = "picochip,pc3x2-rtc" },
        { .compatible = "snps,dw-apb-timer-sp" },
        { /* Sentinel */ },
};

static const struct of_device_id osctimer_ids[] __initconst = {
        { .compatible = "picochip,pc3x2-timer" },
        { .compatible = "snps,dw-apb-timer-osc" },
        {},
};

and thought they were for clocksource and clockevent respectively,
which is wrong.

> But I just looked at clocksource_of_init a bit more closely, which does a 
> for_each_matching_node_and_match over the nodes. So the init_func could grab 
> the device for the clockevent on the first call and the clocksource when it 
> gets called for the second matching node.

Yes, I think that should work. You just have to be careful about calling
init_sched_clock() only once.

	Arnd
