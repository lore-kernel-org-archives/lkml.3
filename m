Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaFCALX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:11:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaFCALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:11:21 -0400
Date: Mon, 02 Jun 2014 17:11:20 -0700 (PDT)
Message-Id: <20140602.171120.192669833635400682.davem@davemloft.net>
To: olof@lixom.net
Cc: rickard_strandqvist@spectrumdigital.se, chas@cmf.nrl.navy.mil,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] atm: fore200e.c: Cleaning up uninitialized variables
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOesGMi4SGRP6_WMgv3xz_QrGScktYGQEK-muCrE=ohFBfeBeQ@mail.gmail.com>
References: <1401577712-4447-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CAOesGMi4SGRP6_WMgv3xz_QrGScktYGQEK-muCrE=ohFBfeBeQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 17:11:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Sun, 1 Jun 2014 17:10:39 -0700

> On Sat, May 31, 2014 at 4:08 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/atm/fore200e.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
>> index 204814e..d4725fc 100644
>> --- a/drivers/atm/fore200e.c
>> +++ b/drivers/atm/fore200e.c
>> @@ -2780,7 +2780,7 @@ static struct pci_driver fore200e_pca_driver = {
>>
>>  static int __init fore200e_module_init(void)
>>  {
>> -       int err;
>> +       int err = 0;
>>
>>         printk(FORE200E "FORE Systems 200E-series ATM driver - version " FORE200E_VERSION "\n");
> 
> 
> I can see how a tool that doesn't know about Kconfig dependencies
> might think so, but if you look at Kconfig you'll see that for this
> driver to be enabled for building either CONFIG_SBUS or CONFIG_PCI
> must be set, and if either of them is then this variable will not be
> used without first being set.

Yeah but it's harmless to apply this, which I've done.
