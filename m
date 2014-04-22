Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaDVIPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:15:49 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50998 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaDVIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:15:35 -0400
Message-ID: <53562523.7020606@linaro.org>
Date: Tue, 22 Apr 2014 09:15:31 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 06/12] mmc: mmci: Add write delay to variant structure.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org> <1398116898-31478-1-git-send-email-srinivas.kandagatla@linaro.org> <20140421220819.GA4468@saruman.home>
In-Reply-To: <20140421220819.GA4468@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Felipe,

On 21/04/14 23:08, Felipe Balbi wrote:
>> +	if (var->reg_write_delay && host->mclk)
>> >+		udelay(1 + ((var->reg_write_delay * USEC_PER_SEC)/host->mclk));
> looks like this should be quirk flag instead of a write delay... No
> strong feelings though, but it looks like the following would be better,
> perhaps:
>
> 	if (host_is_qualcom(host))
> 		udelay(1 + ((3 * USEC_PER_SEC)/host->mclk));
Am ok with your proposal. I was wondering if someone else might need it 
in future.
If not I could change it as you suggested.

Thanks,
srini
>
> --
