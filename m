Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3BLJrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:47:07 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:27218 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751952Ab3BLJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:47:04 -0500
Message-ID: <511A0F73.50008@gaisler.com>
Date: Tue, 12 Feb 2013 10:46:27 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 6/6] of_spi: Initialize cs_gpios and cs_gpio with -EEXIST
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-7-git-send-email-andreas@gaisler.com> <20130211002320.824593E0C13@localhost>
In-Reply-To: <20130211002320.824593E0C13@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-11 01:23, Grant Likely wrote:
> On Tue, 29 Jan 2013 15:53:43 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
>> Holes in the cs-gpios DT phandle list is supposed to mark that native
>> chipselects is to be used. The value returned from of_get_named_gpio_flags in
>> this case is -EEXIST. By initializing cs_gpios and cs_gpio with -EEXIST, this
>> and only this errno will indicate to a spi controller driver that a native
>> chipselect is to be used.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>
> I've left this one off for now. Take a look at the patch I posted and
> let me know if you think this one should still be applied.

I think that of_spi_register_master should return an error when the 
cs-gpios property is broken (part of patch 2) and that cs_gpios and 
cs_gpio should be initialized to the same value as a hole in the plist.

This patch does not work without 1 and 2, so I'll submit a modified 
patch once "of: Create function for counting number of phandles in a 
property" has stabilized. Would it have to go through the gpio branch then?

Cheers,
Andreas

