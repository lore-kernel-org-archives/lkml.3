Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaLEPu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:50:59 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62044 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaLEPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:50:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vishnupatekar <vishnupatekar0510@gmail.com>,
        maxime.ripard@free-electrons.com, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, benh@kernel.crashing.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, robh+dt@kernel.org, msalter@redhat.com,
        vishnupatekar <VishnuPatekar0510@gmail.com>, jdelvare@suse.de
Subject: Re: [PATCH 2/3] drivers:input:ps2 Added sunxi A20 ps2 driver, changed makefile and Kconfig
Date: Fri, 05 Dec 2014 16:50:18 +0100
Message-ID: <2906898.Fr1ixVkiAI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <63D786FF-B293-4FC1-AD71-D99515DE8E3D@gmail.com>
References: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com> <12237550.afophX20rO@wuerfel> <63D786FF-B293-4FC1-AD71-D99515DE8E3D@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:9jfGLSWr+cEwb+bcGZursH/YWfrPA/RRwdkTFGD52BuIWHnCxwl
 2pFPsqL7BwNkNqU+WFBILDSa9CuVLjj8xtPYKwE1lZcfIHsCT4UNzBPz0nC0vL7KGarvE+r
 CMuBXf4im0n2D1375PDA50NzKB6msfaNWM/bbd0j7oGnJti+e6QwduHaO3Au4pLHLEJ3mWF
 YaMp1US/qkrsJqjthJShw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 07:01:17 Dmitry Torokhov wrote:
> 
> On December 5, 2014 2:33:11 AM PST, Arnd Bergmann <arnd@arndb.de> wrote:
> >On Thursday 04 December 2014 04:23:44 vishnupatekar wrote:
> >> +
> >> +struct sunxips2data {
> >> +    int irq;
> >> +    spinlock_t ps2_lock;
> >> +    void __iomem *base_address;     /* virt address of control registers*/
> >> +    struct serio *serio;            /* serio*/
> >> +    struct device *dev;
> >> +    struct  clk     *pclk;
> >> +};
> >
> >As this is dynamically allocated, better embed the serio member
> >directly to avoid allocating both separately.
> 
> That would be wrong - serio is refcounted and it may outlive instance of sunxips2data you embedded it into.

Ok, I see. I guess in this case the use of devm_kzalloc for serio is a bug,
because that would lead to a double free upon module unload, right?

	Arnd
