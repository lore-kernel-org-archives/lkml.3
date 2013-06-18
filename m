Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3FRTMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:12:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3FRTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:12:00 -0400
Message-ID: <51C0B0FC.2090908@wwwdotorg.org>
Date: Tue, 18 Jun 2013 13:11:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "J, KEERTHY" <j-keerthy@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property exists
 and then only request irq
References: <1371549692-7361-1-git-send-email-j-keerthy@ti.com> <1371549692-7361-2-git-send-email-j-keerthy@ti.com> <51C0820B.4020404@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EC563@DBDE04.ent.ti.com> <51C093FF.6000204@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EC5B4@DBDE04.ent.ti.com> <51C09761.1020704@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EC5DB@DBDE04.ent.ti.com>
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EC5DB@DBDE04.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 11:33 AM, J, KEERTHY wrote:
> Stephen Warren wrote at Tuesday, June 18, 2013 10:53 PM:
...>> No, you should just check the IRQ number.
> 
> Hmmm...so something like (!i2c->irq)

Yes.

>> Consider this:
>>
>> If the device was instantiated from a board file *or* a device tree,
>> i2c->irq is correctly set. Hence, checking that value works in both
>> cases.
>>
>> If you check the interrupts DT property, that will only work if the
>> device was instantiated from device tree, and not if it was
>> instantiated from a board file; the property will never exist in the
>> board file case, and hence you'll never be able to have a board file
>> provide an interrupt.
> 
> The board file approach is getting deprecated for this. I
> Myself removed board file related pdata stuff in one of the patches.
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg90598.html
> 
> So going the DeviceTree way.

Even if you're 100% sure this driver will only ever work with DT (which
seems like a bad assumption to make no matter what the circumstance),
it'd still be best to detect whether an IRQ was specified in a generic
way. That way, nobody will read this driver, assume the code is generic,
and just copy/paste it without thinking.
