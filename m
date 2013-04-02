Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3DBPdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:33:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:49980 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761236Ab3DBPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:33:18 -0400
Message-ID: <515AFA0B.7020509@interlog.com>
Date: Tue, 02 Apr 2013 11:32:27 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-arm-kernel@lists.infradead.org, jhovold@gmail.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] rtc: rtc-at91rm9200: manage IMR depending on revision
References: <1364573029-19346-5-git-send-email-jhovold@gmail.com> <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-04-02 09:06 AM, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi all,
>
> The funny thing is that I was writing exactly the same code as Johan's
> when he posted his series.
>
> So, here is my single patch, with the comment about the readback stolen from
> Johan's, but without the way to determine with IP is buggy and which one is
> not...
> After having dug the possibility to read the IP revision, I discovered that it
> is not possible to use this information ("version" register offset changing
> according to... IP version number: well done!).
> In conclusion, I guess that the only way to determine if we need the workaround
> is to use the DT.
> One remark though: if we use the compatibility string for this purpose, I fear
> that we would twist the meaning of this information: SoC using an
> "atmel,at91sam9x5-rtc" compatible RTC will not necessarily be touched by the
> "non responding IMR" bug: at91sam9n12 or upcoming sama5d3 are not affected for
> instance, and we need to cling to "atmel,at91rm9200-rtc" for them...
> I think that we can use this method for the moment and move to another
> compatibility string later if it is needed.

Rather than have so many people working on rtc-at91rm9200.c,
how about someone bring its "RTT" sibling into the DT
world. I'm talking about drivers/rtc/rtc-at91sam9.c ...

Doug Gilbert

