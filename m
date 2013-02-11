Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3BKKPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:15:11 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:59565 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3BKKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:15:09 -0500
Message-ID: <5118C458.2070205@synopsys.com>
Date: Mon, 11 Feb 2013 15:43:44 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal
 handling)
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-9-git-send-email-vgupta@synopsys.com> <51189D2F.4030000@synopsys.com> <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com>
In-Reply-To: <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 03:06 PM, Jonas Bonn wrote:
> On 11 February 2013 08:26, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
>> The only downside of this patch is that userspace signal stack grows in size,
>> since signal frame only cares about scratch regs (pt_regs), but has to accommodate
>> unused placeholder for callee regs too by virtue of using user_regs_struct.
> Is this really true?  Don't setcontext and friends require that _all_
> the registers be part of sigcontext?

But for an ABI - callee saved regs will anyhow be saved/restored even in
setcontext case ! So collecting it for that purpose seems useless, or am I missing
something here.

-Vineet

