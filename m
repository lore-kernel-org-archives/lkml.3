Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaKSHJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:09:04 -0500
Received: from mout.web.de ([212.227.15.4]:51254 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbaKSHJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:09:01 -0500
Message-ID: <546C41EF.4040502@users.sourceforge.net>
Date: Wed, 19 Nov 2014 08:08:31 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kprobes: Deletion of an unnecessary check before
 the function call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net> <5469B08E.90104@hitachi.com>
In-Reply-To: <5469B08E.90104@hitachi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:tfJjuXm+BlPfGve/gpxUGFFR/oUY0M9K2R6Qq9P9hB8RbOXX0T+
 /foK9VFlWYfKgeHh4zvLkL359leFKHUz2DuCBN+WIpB1bHrcv9rN3NUIPP6mUffT/UhPlax
 Kn6kWHIMqjW65Fat9zTocEBqmy7uo872FwYePQ7Lru+l5rlIv2G96XodZBwln0KKfUglGOk
 vUgQmHHyJsKxGreImIOXw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> This is OK, but I you request a comment line over there so that
> code reader can understand it is safe to pass a NULL pointer to
> module_put().

Do you want that I replace the shown null pointer check by a short
comment which repeats an expectation for the affected function call?

Regards,
Markus

