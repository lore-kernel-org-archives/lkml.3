Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaJ1TlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:41:11 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:46439 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJ1TlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:41:09 -0400
X-IronPort-AV: E=Sophos;i="5.04,804,1406617200"; 
   d="scan'208";a="49344094"
Message-ID: <544FF150.3090504@broadcom.com>
Date: Tue, 28 Oct 2014 12:41:04 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH v7 4/7] ARM: dts: Enable Broadcom Cygnus SoC
References: <1414011474-11821-5-git-send-email-sbranden@broadcom.com> <12464460.6zhqY1bzdG@wuerfel>
In-Reply-To: <12464460.6zhqY1bzdG@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.  Will send out v8 version.  Hopefully for finally 
approval.

On 14-10-28 09:10 AM, Arnd Bergmann wrote:
> On Wednesday 22 October 2014 13:57:51 Scott Branden wrote:
>> +
>> +       aliases {
>> +               serial0 = &uart3;
>> +               serial1 = &uart0;
>> +       };
>> +
>> +       chosen {
>> +               bootargs = "console=ttyS0,115200 earlyprintk debug";
>> +       };
>>
>
> Please move the 'aliases' and 'chosen' node into the .dts files, these
> are board specific, not SoC specific.
ok.
>
> For chosen, please remove earlyprintk and debug, which don't normally
> make sense unless you are debugging, and which will break in a multiplatform
> kernel.
ok.
>
> Please also add an "stdout-path = &uart3" property in chosen so that
> earlycon can work. Note that earlycon is currently broken on arm32,
> but we'll get there.
ok.
>
> 	Arnd
>

