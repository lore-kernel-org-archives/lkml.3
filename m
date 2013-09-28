Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3I1TnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:43:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48655 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab3I1TnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:43:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130928192545.GB8228@gmail.com>
References: <20130927143249.GD4422@pd.tnic> <20130927143554.GF4422@pd.tnic> <20130928082542.GA18198@gmail.com> <20130928102305.GA5956@pd.tnic> <20130928134449.GB26931@gmail.com> <20130928174749.GE5956@pd.tnic> <20130928175444.GA4402@gmail.com> <20130928180459.GF5956@pd.tnic> <20130928181236.GA4999@gmail.com> <20130928191500.GG5956@pd.tnic> <20130928192545.GB8228@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 28 Sep 2013 12:42:37 -0700
To: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Message-ID: <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about:

m = 10;
d = 1;

while ( val >= m ) {
        m *= 10;
        d++;
}

... and not have a *divide* in there?

Man, entering code on a cell phone sucks...
        

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Borislav Petkov <bp@alien8.de> wrote:
>
>> @@ -2,6 +2,10 @@ int num_digits(int val)
>>  {
>>  	int digits = 0;
>>  
>> +	/* Handle special case */
>> +	if (!val)
>> +		return 1;
>> +
>>  	while (val) {
>>  		val /= 10;
>>  		digits++;
>
>Hm. I suspect this could then be written as:
>
>int num_digits(int val)
>{
>	int digits = 0;
>
>	do {
>		val /= 10;
>		digits++;
>	} while (val);
>
>	return digits;
>}
>
>No ugly special case! :-)
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
