Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaGSANO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:13:14 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:41731 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaGSANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:13:12 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-77-53c9b8168388
Message-id: <53C9B814.4020809@samsung.com>
Date: Fri, 18 Jul 2014 18:13:08 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
 <20140718232958.GA22487@ravnborg.org>
In-reply-to: <20140718232958.GA22487@ravnborg.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.212]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9hP12xHSeDDWbvt7JoXryezeLPrh1M
	Fpd3zWGzaNl3gclixc+tjA6sHvvnrmH3WDLtKpvHmQVH2D0+b5ILYInisklJzcksSy3St0vg
	yuiYeYm9YCt3Rc/yR8wNjLM4uxg5OSQETCTerf/NBmGLSVy4tx7I5uIQEljGKLFozglmCKeX
	SeLC7GnsEM42RolTq+aAtfAKaEns/r2GEcRmEVCVuLjnBlicTUBd4vPrHewgtpCAnETTktXM
	ILaoQITEgb5nrBC9ghI/Jt9jAbFFBJQljp+/BhZnFsiR2NR2EiwuLBAicerbSag5ORKtl9rB
	dnEKGEn827CABaLeWmLlpG2MELa8xOY1b5kh6pUl/lw+xQTxmrLE1Nm/mScwisxCsnoWkvZZ
	SNoXMDKvYhQrLU4uKE5KT60w1itOzC0uzUvXS87P3cQIiZaaHYz3vtocYhTgYFTi4d2hdTJY
	iDWxrLgy9xCjBAezkgivyxqgEG9KYmVValF+fFFpTmrxIUYmDk6pBsapiz/eXWS5PsrMu/Le
	NKd1f87zVsrZqSwWVJkQt0RScI1r9quFffs4lq/YvO7OWYZX6W3swa+Xt4tPKdy9PeAIg2ma
	29T1W9tU39l6rP+7wUFWdnqX/PQmu/MTGFd7JPes/ieyrrV1kUiKlpxb/wV99WkrbaWOcqed
	WX1I4dbZbQ42U1+oOF9SYinOSDTUYi4qTgQA1zKSB3QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 05:29 PM, Sam Ravnborg wrote:
> On Fri, Jul 18, 2014 at 02:44:34PM -0600, Shuah Khan wrote:
>> Add a new devtest make target to enable developer testing. This
>> new target does full build (make all) and then runs selftests.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   Makefile | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index f3c543d..1ef3128 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1034,6 +1034,14 @@ headers_check: headers_install
>>   	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
>>
>>   # ---------------------------------------------------------------------------
>> +# Kernel devtest
>> +
>> +PHONY += devtest
>> +devtest:
>> +	make all
>> +	make -C tools/testing/selftests run_tests
>
> The name "devtest" does not give any hints that we are actually
> running the suite of selftest programs.
>
> Is it so because the plan is to extend devtest to cover more than just selftest?
> If not please fix it so it is logical for the user what happens - in other
> words name is selftest or something like that.
>

Yes the intent is to cover more than just selftests in the future.
That is why the target is called devtest.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
