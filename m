Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3CUJqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:46:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11054 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3CUJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:46:34 -0400
Message-ID: <514AD6F2.20701@atmel.com>
Date: Thu, 21 Mar 2013 10:46:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dgilbert@interlog.com>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com> <20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
In-Reply-To: <20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:50 PM, Andrew Morton :
> On Fri, 15 Mar 2013 18:37:12 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> On some revisions of AT91 SoCs, the RTC IMR register is not working.
>> Instead of elaborating a workaround for that specific SoC or IP version,
>> we simply use a software variable to store the Interrupt Mask Register and
>> modify it for each enabling/disabling of an interrupt. The overhead of this
>> is negligible anyway.
> 
> This description doesn't really allow me or others to work out whether
> the fix should be included in 3.9 or backported into earlier kernels.
> 
> So please, when fixing a bug do include a full description of the
> user-visible effects of that bug.  And your opinion regarding the
> -mainline and -stable decision is always useful.

Yes, sure.

Concerning this patch, we can imagine to push it upstream as a bugfix
for 3.9-rc. It is not a regression because... well... it has never
worked properly on the affected SoC family.

For -stable, we can add this tag:

Cc: stable <stable@vger.kernel.org> [v3.8+]


As this patch applies up to this revision. For other kernel releases, I
will need to rework the patch a little bit due to files name modifications.

Thanks, best regards,
-- 
Nicolas Ferre
