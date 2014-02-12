Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBLLnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:43:21 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40371 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105AbaBLLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:43:18 -0500
Message-ID: <1392205398.848.10.camel@hornet>
Subject: Re: [PATCH 07/12] mfd: syscon: Consider platform data a regmap
 config name
From: Pawel Moll <pawel.moll@arm.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Feb 2014 11:43:18 +0000
In-Reply-To: <1392204460.1197803@f433.i.mail.ru>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <20140212082657.GK15081@lee--X1> <1392203209.3380.57.camel@hornet>
	 <1392204460.1197803@f433.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 11:27 +0000, Alexander Shiyan wrote:
> Yeah, I gave up the idea to use the syscon_ids[] to separate devices for
> non-DT case.
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/mfd/syscon.c?id=5104d2656d4874c51868dc7182016e9501ec99ca
> Instead, I use a hard definition for pdev->id, so that the names of
> syscon-devices are different and can be obtained from the driver
> it uses with syscon_regmap_lookup_by_pdevname().

It is a sort-of-solution (I personally dislike magic numbers, but this
is a separate discussion) for a completely-non-DT case, where you can
guarantee limited number of syscon devices.

In my case I have a DT system, where some of the MFD devices *may*
register syscon cells... No way to enforce ordering.

> I understand this topic correct?

The main idea here is to attach a meaningful label to the syscon
regmaps. My example:

/ # ls -d1 /sys/kernel/debug/regmap/syscon.*
/sys/kernel/debug/regmap/syscon.0.auto
/sys/kernel/debug/regmap/syscon.4.auto
/sys/kernel/debug/regmap/syscon.5.auto

vs

/ # ls -d /sys/kernel/debug/regmap/syscon.*
/sys/kernel/debug/regmap/syscon.0.auto-sys_id
/sys/kernel/debug/regmap/syscon.4.auto-sys_misc
/sys/kernel/debug/regmap/syscon.5.auto-sys_procid

Of course one could also define syscon_regmap_lookup_by_label() (I don't
really need it right now so didn't go that way)

Pawel

