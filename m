Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaKTDxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:53:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58690 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaKTDxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:53:51 -0500
Message-ID: <546D65C6.3030109@hitachi.com>
Date: Thu, 20 Nov 2014 12:53:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kprobes: Deletion of an unnecessary check before
 the function call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net> <5469B08E.90104@hitachi.com> <546C41EF.4040502@users.sourceforge.net>
In-Reply-To: <546C41EF.4040502@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/19 16:08), SF Markus Elfring wrote:
>>> index 3995f54..f1e7d45 100644
>>> --- a/kernel/kprobes.c
>>> +++ b/kernel/kprobes.c
>>> @@ -1527,8 +1527,7 @@ int register_kprobe(struct kprobe *p)
>>>  out:
>>>  	mutex_unlock(&kprobe_mutex);
>>>  
>>> -	if (probed_mod)
>>> -		module_put(probed_mod);
>>> +	module_put(probed_mod);
>>
>> This is OK, but I you request a comment line over there so that
>> code reader can understand it is safe to pass a NULL pointer to
>> module_put().
> 
> Do you want that I replace the shown null pointer check by a short
> comment which repeats an expectation for the affected function call?

No, not "want". IMHO, if try_module_get(mod) is done only when mod!=NULL,
we shouldn't call module_put(mod) when mod==NULL (even if it is possible),
because those get/put method must be used as a pair, for the better
understandings.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


