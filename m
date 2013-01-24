Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3AXKMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:12:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3AXKM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:12:29 -0500
Message-ID: <51010908.5090105@ti.com>
Date: Thu, 24 Jan 2013 11:12:24 +0100
From: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <v-stehle@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regmap: debugfs: Fix compilation warning
References: <1358779015-25735-1-git-send-email-v-stehle@ti.com> <20130122064121.GC1766@opensource.wolfsonmicro.com> <50FE64C8.8040407@ti.com> <20130123155834.GD4565@opensource.wolfsonmicro.com>
In-Reply-To: <20130123155834.GD4565@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 04:58 PM, Mark Brown wrote:
> On Tue, Jan 22, 2013 at 11:07:04AM +0100, Vincent Stehlé wrote:
> 
>> Do you think there is a way to "mark" the list_for_each_entry()
>> as iterating at least once? an __attribute__ maybe?
> 
> No - but are you sure that's true?

If you mean "am I sure the loop iterates at least once", then yes, as
we have an explicit check just before the concerned list_for_each_entry():

	/*
	 * This should never happen; we return above if we fail to
	 * allocate and we should never be in this code if there are
	 * no registers at all.
	 */
	if (list_empty(&map->debugfs_off_cache)) {
		WARN_ON(list_empty(&map->debugfs_off_cache));
		return base;
	}

Best regards,

V.

