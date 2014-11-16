Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaKPO0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 09:26:19 -0500
Received: from mout.web.de ([212.227.15.14]:53537 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbaKPO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 09:26:18 -0500
Message-ID: <5468B3FD.20409@users.sourceforge.net>
Date: Sun, 16 Nov 2014 15:26:05 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] kprobes: Deletion of an unnecessary check
 before the function call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net> <alpine.DEB.2.10.1411161428190.2364@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411161428190.2364@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:sSw/GUXgJhsiSV9y7vVvUO5m47aEOZrjuW23v20WzhsS570+cmz
 HbwPMEVQhzlB9YrxLNZCRlF8TgJnZIXb6YlrEhGs1KR3aktCqB1tHZh37IfCd295O1TEia/
 /8bX6u5JTRz/RQTjfaZQzGozW4+eIDEVeEwLqRNPaZ9cWm2ksZoKo3GU9O/QPnXMWosxRRA
 0wowjtV5sNzR1NucjIhbQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 3995f54..f1e7d45 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -1527,8 +1527,7 @@ int register_kprobe(struct kprobe *p)
>>  out:
>>  	mutex_unlock(&kprobe_mutex);
>>
>> -	if (probed_mod)
>> -		module_put(probed_mod);
>> +	module_put(probed_mod);
> 
> There is an out label, so please check whether the labels could not be
> better positioned to avoid calling module_put when it is not needed.

I do not see refactoring opportunities around jump labels in this use case
for the implementation of the register_kprobe() function so far because
the mutex_unlock() function must be called.
Would you like to suggest any other source code fine-tuning?

Regards,
Markus
