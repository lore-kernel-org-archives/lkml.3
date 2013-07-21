Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3GUU7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:59:54 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61707 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3GUU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307211535210.4893@kaball.uk.xensource.com>
References: <1374239399-2498-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307211535210.4893@kaball.uk.xensource.com>
From: Julien Grall <julien.grall@linaro.org>
Date: Sun, 21 Jul 2013 21:59:22 +0100
Message-ID: <CAPnVf8yG4VecBkk8py_cyOiFkFMqiLYydicKcM2PgYYm+gKd8w@mail.gmail.com>
Subject: Re: [PATCH v2] xen/arm: enable PV control for ARM
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Patch Tracking <patches@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 July 2013 15:54, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Fri, 19 Jul 2013, Julien Grall wrote:
>> Enable power management from the toolstack for ARM guest.
>>
>> Signed-off-by: Julien Grall <julien.grall@linaro.org>
>>
>> ---
>>     Changes in v2:
>>         - Don't compile xen/cpu_hotplug.o with ARM64
>> ---
>>  drivers/xen/Makefile |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 2bf461a..b550a94 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -1,9 +1,8 @@
>> -ifneq ($(CONFIG_ARM),y)
>> -obj-y        += manage.o
>> +ifneq ($(filter y, ($CONFIG_ARM) $(CONFIG_ARM64)),y
>
> This is wrong: ifneq is checking for the opposite condition of what we want, and
> beside you have the $ in the wrong place for CONFIG_ARM.
>
> Please test you patches before sending them.

My apologies, I tried without any issue on ARM (certainly, because of
the $ in wrong place).

I will send a new patch.

--
Julien Grall
