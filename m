Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaJBRTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:19:06 -0400
Received: from muin.pair.com ([209.68.1.55]:49792 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaJBRTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:19:04 -0400
Message-ID: <542D8905.2070004@tabi.org>
Date: Thu, 02 Oct 2014 12:19:01 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29.1
MIME-Version: 1.0
To: German Rivera <German.Rivera@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        stuart.yoder@freescale.com, Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 3/3 v2] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>	<1411166981-3610-4-git-send-email-German.Rivera@freescale.com> <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com> <542D7F16.4000304@freescale.com>
In-Reply-To: <542D7F16.4000304@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

German Rivera wrote:
>>
> I know that this is not necessary from the point of view of C boolean
> semantics, but doing explicit comparison improves readability IMHO.

I guess we'll have to agree to disagree.  I think it makes the code less 
readable.

> Anyway, this is subjective and largely a matter of preference.
> Besides, "Documentation/CodingStyle" does not seem to advocate one way
> or the other.

CodingStyle is a starting point, not the final word.  If I had a dime 
whenever someone insisted a code snippet is okay because it's not 
covered by CodingStyle, I could retire.

> Also, I there is evidence that explicit comparisons are allowed in
> the kernel source tree:

Allowed != preferred.  Besides, there are tons of examples of almost 
every style mistake in the kernel today.  Some code is really old, or it 
was accepted by lazy maintainers and never fixed.  You can't really use 
that as a basis for a decision.


>>> +int __must_check dprc_scan_container(struct fsl_mc_device *mc_bus_dev);
>>> +
>>> +int __must_check dprc_scan_objects(struct fsl_mc_device *mc_bus_dev);
>>
>> __must_check?  Really?

> Yes, to ensure that callers that are not checking the return code from
> dprc_scan_objects() are caught at compile-time (CHECK time).

I know what __must_check is for.  I'm just saying that you kinda need to 
justify using it.  It's like using likely() on non-time-critical code. 
Overuse is worse than not using it at all, and I don't see what's so 
special about these functions that they need __must_check.

(on a side note, you're supposed to bcc: 
linuxppc-release@linux.freescale.net, not cc: it.)
