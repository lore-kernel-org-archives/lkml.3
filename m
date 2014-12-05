Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLEPBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:01:30 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64660 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLEPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:01:28 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <12237550.afophX20rO@wuerfel>
References: <1417647224-27950-1-git-send-email-VishnuPatekar0510@gmail.com> <12237550.afophX20rO@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/3] drivers:input:ps2 Added sunxi A20 ps2 driver, changed makefile and Kconfig
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 05 Dec 2014 07:01:17 -0800
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: vishnupatekar <vishnupatekar0510@gmail.com>,
        maxime.ripard@free-electrons.com, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, benh@kernel.crashing.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, robh+dt@kernel.org, msalter@redhat.com,
        vishnupatekar <VishnuPatekar0510@gmail.com>, jdelvare@suse.de
Message-ID: <63D786FF-B293-4FC1-AD71-D99515DE8E3D@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On December 5, 2014 2:33:11 AM PST, Arnd Bergmann <arnd@arndb.de> wrote:
>On Thursday 04 December 2014 04:23:44 vishnupatekar wrote:
>> +
>> +struct sunxips2data {
>> +	int irq;
>> +	spinlock_t ps2_lock;
>> +	void __iomem *base_address;	/* virt address of control registers*/
>> +	struct serio *serio;		/* serio*/
>> +	struct device *dev;
>> +	struct	clk	*pclk;
>> +};
>
>As this is dynamically allocated, better embed the serio member
>directly to avoid allocating both separately.

That would be wrong - serio is refcounted and it may outlive instance of sunxips2data you embedded it into.


Thanks.

-- 
Dmitry
