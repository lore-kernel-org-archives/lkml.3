Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaLDW1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:27:09 -0500
Received: from mout.web.de ([212.227.15.14]:49568 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbaLDW1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:27:06 -0500
Message-ID: <5480DFB5.4090708@users.sourceforge.net>
Date: Thu, 04 Dec 2014 23:27:01 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by pr_warn()
 in mppe_rekey()
References: <5307CAA2.8060406@users.sourceforge.net>	 <530A72AA.3000601@users.sourceforge.net>	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>	 <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>	 <547C82A6.2030808@users.sourceforge.net>	 <547CA157.1080401@cogentembedded.com>	 <5480DA32.8000201@users.sourceforge.net>	 <5480DBDE.7040604@users.sourceforge.net> <1417731809.2721.17.camel@perches.com>
In-Reply-To: <1417731809.2721.17.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7Yz/Q4/aM+oeGcJdUIK6zFa60ps/CPz5H+bls4iLrXAMoGea1XO
 5Dv8LM17aiDFw8koIeOttv1Icg+sTjPa+MHgbqkpMy35qVkf34b8xaYpnszkwv+1/hkA1uT
 4N5jnW2SCIbjSL1cASoNFoem3hG4fBn7j0tBSg/PdN2MkjdZ93yznHMiFaHxUh/Q40wpcfJ
 uwiFB/cNmY+fGkxcL9fFg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
> []
>> @@ -172,9 +172,8 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
>>  		setup_sg(sg_in, state->sha1_digest, state->keylen);
>>  		setup_sg(sg_out, state->session_key, state->keylen);
>>  		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
>> -					     state->keylen) != 0) {
>> -    		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
>> -		}
>> +					     state->keylen) != 0)
>> +			pr_warn("mppe_rekey: cipher_encrypt failed\n");
> 
> It's generally nicer to replace embedded function names
> with "%s: ", __func__
> 
> 			pr_warn("%s: cipher_encrypt failed\n", __func__);

Do you want that I send a third patch series for the fine-tuning of these parameters?

Regards,
Martkus

