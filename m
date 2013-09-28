Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3I1TZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:25:52 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41319 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3I1TZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:25:48 -0400
Date: Sat, 28 Sep 2013 21:25:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928192545.GB8228@gmail.com>
References: <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
 <20130928134449.GB26931@gmail.com>
 <20130928174749.GE5956@pd.tnic>
 <20130928175444.GA4402@gmail.com>
 <20130928180459.GF5956@pd.tnic>
 <20130928181236.GA4999@gmail.com>
 <20130928191500.GG5956@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928191500.GG5956@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> @@ -2,6 +2,10 @@ int num_digits(int val)
>  {
>  	int digits = 0;
>  
> +	/* Handle special case */
> +	if (!val)
> +		return 1;
> +
>  	while (val) {
>  		val /= 10;
>  		digits++;

Hm. I suspect this could then be written as:

int num_digits(int val)
{
	int digits = 0;

	do {
		val /= 10;
		digits++;
	} while (val);

	return digits;
}

No ugly special case! :-)

Thanks,

	Ingo
