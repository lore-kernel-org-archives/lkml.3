Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaEFPRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:17:09 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45986 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaEFPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:17:07 -0400
Message-ID: <5368FCF0.90508@gmail.com>
Date: Tue, 06 May 2014 17:17:04 +0200
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Boris BREZILLON <brezillonboris@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: set interface name based on DT aliases
References: <1394620196-6295-1-git-send-email-b.brezillon.dev@gmail.com> <20140505204022.GA27961@quad.lixom.net>
In-Reply-To: <20140505204022.GA27961@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 05/05/2014 22:40, Olof Johansson wrote:
> On Wed, Mar 12, 2014 at 11:29:56AM +0100, Boris BREZILLON wrote:
>> Use aliases to set the interface name (ethX) instead of automatic
>> assignement.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>>
>> Hello Nicolas, Jean-Christophe,
>>
>> This is an example on how we could set the ethernet interface id based on DT
>> aliases.
>> As you can see this patch is not properly separated.
>>
>> I'm still not happy with this approach for several reasons:
>> 1) If another ethernet iface has already been registered with the same id the
>>    net dev registration will fail.
>> 2) We bypass the ethernet macros/functions and directly use the net device
>>    functions which IMHO is not future proof.
> [Sorry for the late reply, going through old backlog of unread email]
>
> Looks like this should live in networking core instead of in the driver, it's
> how we handle it in other subsystems.

Sure.
This version was just a quick an dirty hack, but I'll send a new version
integrating this functionality in netdev core.

> I don't know what DaveM's opinions on that is though.

I'll put him in Cc of the next version.

Best Regards,

Boris
