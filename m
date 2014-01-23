Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaAWKld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:41:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54463 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaAWKlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:41:31 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fe-52e0f1d9e446
Message-id: <52E0F1D7.4030401@samsung.com>
Date: Thu, 23 Jan 2014 11:41:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH 8/8 v4] crypto:s5p-sss: Use clk_prepare/clk_unprepare
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
 <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
 <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
In-reply-to: <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7o3Pz4IMtg6n9/i7vPDjBYvD2la
	dL+Ssbh/7yeTxeVdc9gsZpzfx2SxaNt/ZotVu/4wWpydc4jJgdNj56y77B7bDqh69G1Zxejx
	eZNcAEsUl01Kak5mWWqRvl0CV0bD8pPMBbfZK26cPsrYwDiRrYuRg0NCwETi306+LkZOIFNM
	4sK99UBhLg4hgaWMEi/aFzFCOJ8YJS7vPsYEUsUroCXxadVyNhCbRUBVovPLahYQm03AUKL3
	aB8jiC0qECHxd956Roh6QYkfk++B1YgIpEn0THjNCjKUWeAfo8STgzPAhgoLeErc23yXCWLb
	CUaJ/dPns4OcxykQLNEyOwekhllAR2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6RUn5haX5qXrJefnbmKEhPrXHYxLj1kdYhTgYFTi4U38cj9IiDWxrLgy9xCj
	BAezkgjvhTcPgoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzmJYNHtr8s+apy8yPxsZXHB5s2lK
	ysuXBWfOOc9326rZtKn+0OuSQ8kuR+eYrLvU1/zI6fKs6JIo+UqBsEkeAvwNa0sT17Nc6Jaa
	ueFde+bnr/5Gp9RfXV9RF31hWppVctjB66c37/j72jx72y2v9qyZMn+OHL7j+Gf2dPu5Jnvb
	FfOq6g3+xyixFGckGmoxFxUnAgDG35F+UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/01/14 11:18, Naveen Krishna Ch wrote:
> Hello All,
> 
> On 15 January 2014 14:47, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> This patch set adds use of clk_prepare/clk_unprepare as
>> required by generic clock framework.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>> Changes since v3:
>> None
>>
>>  drivers/crypto/s5p-sss.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index f7c66c7..870e794 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -648,7 +648,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>                 return -ENOENT;
>>         }
>>
>> -       clk_enable(pdata->clk);
>> +       clk_prepare_enable(pdata->clk);

How about properly checking the return value ?

--
Thanks,
Sylwester
