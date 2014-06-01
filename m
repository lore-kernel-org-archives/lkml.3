Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaFATg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:36:59 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34740 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaFATg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <CBA48B605613B640864883107238931C13AC20@nice.asicdesigners.com>
References: <1401626055-15144-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CBA48B605613B640864883107238931C13AC20@nice.asicdesigners.com>
Date: Sun, 1 Jun 2014 21:36:57 +0200
Message-ID: <CAFo99gbeRu=D4LqO=i43GfCY+opR_o+wwOo0u4VuxUKBNG+Xmw@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: chelsio: cxgb4: t4_hw.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dimitrios Michailidis <dm@chelsio.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dimitrios!

Okay sorry, I see what you mean...

Best regards
Rickard Strandqvist


2014-06-01 21:11 GMT+02:00 Dimitrios Michailidis <dm@chelsio.com>:
> Rickard Strandqvist wrote:
>> There is a risk that the variable will be used without being initialized.
>
> There isn't actual risk here, this variable is not used uninitialized AFAICS.
>
>> This was largely found by using a static code analysis program called cppcheck.
>
> It seems this is a false inference by the tool.  I think the preferred method to suppress false tool warnings is to use uninitialized_var.
>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> index bba6768..326c005 100644
>> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> @@ -571,7 +571,7 @@ int t4_seeprom_wp(struct adapter *adapter, bool
>> enable)
>>   */
>>  int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
>>  {
>> -     u32 cclk_param, cclk_val;
>> +     u32 cclk_param, cclk_val = 0;
>>       int i, ret, addr;
>>       int ec, sn, pn;
>>       u8 *vpd, csum;
>> --
>> 1.7.10.4
>
