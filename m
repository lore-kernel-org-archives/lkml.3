Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaJOMwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:52:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63294 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaJOMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:52:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-43-543e6dff83a5
Content-transfer-encoding: 8BIT
Message-id: <1413377533.26771.16.camel@AMDC1943>
Subject: Re: [PATCH 0/7] power_supply: Decrement the device reference counter
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 15 Oct 2014 14:52:13 +0200
In-reply-to: <20141015121841.GA26579@amd>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
 <20141015121841.GA26579@amd>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t/xK7r/c+1CDGZds7A4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLZYtfspocbbpDbvF/a9HGS2m/FnOZLHp8TVWi8u75rBZfO49
	wmjxcekGVou1R+6yW1w6sIDJ4u6po2wWj1e8Zbc43c1qcXp3icXmTVOZLX5seMzqIOYxof8T
	o8fOWXfZPRZsKvXYvELLY/Gel0wem1Z1snncubaHzePduXPsHvNOBnpsXlLv8fHpLRaP9/uu
	snn0bVnF6LFi9Xd2j8+b5DxOtHxhDRCI4rJJSc3JLEst0rdL4MqY+ucIa8Futoozj+6yNDBO
	YO1i5OSQEDCR2P1mLwuELSZx4d56ti5GLg4hgaWMEutbn7CBJHgFBCV+TL4HVMTBwSwgL3Hk
	UjZImFlAXWLSvEXMEPWfGSVau04yQtQbSKx89YUJxBYW8JXYtvIMmM0mYCyxefkSsJkiQHO2
	9q0Aa2YW2MkmceneSWaQBIuAqsSpPXfBGjgFNCUaX10GiwsJpEksu72NFeQICQFlicZ+twmM
	ArOQnDcL4bxZSM5bwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkqr/uYFx6zOoQowAH
	oxIPL8cB2xAh1sSy4srcQ4wSHMxKIrzzE+xChHhTEiurUovy44tKc1KLDzEycXBKNTAaRdjv
	9JLYoWF3Na/m0OU9xRmnGdY+XmM9N32H4xTHlLkaqevS9ncwmqzp4WOwqw2Qe/2iTtg3NXxt
	merr6e3X61/mf+WNjfm8JuTrk52M1kdKV6rN2Vo0LfK2z6GOmR4iqwUjda5ISOzg7V3gr5Hb
	c2EmS17msYq/u44e92WzNAuNCw45MVmJpTgj0VCLuag4EQDI2A9QyAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-15 at 14:18 +0200, Pavel Machek wrote:
> Hi!
> 
> > The reference counter of device allocated for power supply was
> > incremented with each call to power_supply_get_by_name() and
> > power_supply_get_by_phandle().
> > 
> > Add a symmetric 'put' operation so the device could be released after
> > final put_device() call during supply unregistering.
> > 
> > 
> > Rebased on next-20141007 + mine [1] patchset.
> > Tested on Trats2 board (max77693 + charger manager).
> > 
> > Kindly asking for reviewing/testing other drivers.
> 
> I'm not sure if we should support power_supply_put(NULL), but
> otherwise the series looks ok to me.
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks for reviewing. I'll remove the non-NULL check and resend with
your ack.

Best regards,
Krzysztof

