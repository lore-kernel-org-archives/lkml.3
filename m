Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3F1OBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:01:32 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:57745 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab3F1OBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:01:31 -0400
Message-ID: <51CD95FE.6070205@st.com>
Date: Fri, 28 Jun 2013 14:56:14 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: st: Fix checking return value of syscon_regmap_lookup_by_phandle()
References: <1372415628.1860.1.camel@phoenix> <51CD6743.3050603@st.com> <CAFRkauBbajREymRRZ8rbB6nzw4KgPWSd684Qz75MekcLzpoR=g@mail.gmail.com>
In-Reply-To: <CAFRkauBbajREymRRZ8rbB6nzw4KgPWSd684Qz75MekcLzpoR=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/13 13:16, Axel Lin wrote:
> 2013/6/28 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
>> Thankyou Axel for looking at this.
>>
>> There is already a patch is submitted for this.
>> https://lkml.org/lkml/2013/6/26/494 which I have Acked.
> 
> That is strange.
> I don't think the patch you mentioned can be applied to current pinctrl tree.
> Current code does check pinctrl_register by IS_ERR.
The patch removes the IS_ERR, because, pinctrl_register returns NULL or
a valid pointer, using IS_ERR is this case is incorrect.

Thanks,
srini
> 
>         info->pctl = pinctrl_register(pctl_desc, &pdev->dev, info);
>         if (IS_ERR(info->pctl)) {

> 
> Regards,
> Axel
> 

