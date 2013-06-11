Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3FKDHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:07:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48747 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3FKDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:07:31 -0400
Message-ID: <51B6946B.4050803@linaro.org>
Date: Tue, 11 Jun 2013 08:37:23 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 01/15] sparc,leon: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-2-git-send-email-tushar.behera@linaro.org> <CAK9yfHyndkfDV6K4brkk06BHQAW=v-gpDw5w+dRqGrKhQ0yuFA@mail.gmail.com>
In-Reply-To: <CAK9yfHyndkfDV6K4brkk06BHQAW=v-gpDw5w+dRqGrKhQ0yuFA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:33 PM, Sachin Kamat wrote:
> On 10 June 2013 17:04, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>> introduced devm_ioremap_resource() and deprecated the use of
>> devm_request_and_ioremap().
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> CC: sparclinux@vger.kernel.org
>> CC: "David S. Miller" <davem@davemloft.net>
>> ---
>> * Not compile tested.
>>  arch/sparc/kernel/leon_pci_grpci1.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
>> index 7739a54..23497f4 100644
>> --- a/arch/sparc/kernel/leon_pci_grpci1.c
>> +++ b/arch/sparc/kernel/leon_pci_grpci1.c
>> @@ -536,10 +536,10 @@ static int grpci1_of_probe(struct platform_device *ofdev)
>>
>>         /* find device register base address */
>>         res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
>> -       regs = devm_request_and_ioremap(&ofdev->dev, res);
>> -       if (!regs) {
>> +       regs = devm_ioremap_resource(&ofdev->dev, res);
>> +       if (IS_ERR(regs)) {
>>                 dev_err(&ofdev->dev, "io-regs mapping failed\n");
> 
> You may remove the above error message as devm_ioremap_resource prints
> its own error messages.
> 

Ok. I will remove the error message. I will do the same for other
instances too.

Thanks.

-- 
Tushar Behera
