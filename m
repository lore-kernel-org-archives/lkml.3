Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaLAPBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:01:08 -0500
Received: from mout.web.de ([212.227.17.12]:57047 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaLAPBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:01:06 -0500
Message-ID: <547C82A6.2030808@users.sourceforge.net>
Date: Mon, 01 Dec 2014 16:00:54 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] net-PPP: Deletion of unnecessary checks before the
 function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>
In-Reply-To: <547C5CBC.6060607@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ib/pZ9LwBY8emsSLd3hAuO+CweSNCGkFfeD+wwM3r3xBxDUchnr
 dVbLR3wQ/lro4Pv5hYdexVJoT2QUZm9TbB7GoWeUdrBgNhVa2RTxgW+MXTc+FfOp1XZDVNh
 ZGb5W8/shHWoaW9IkFZw3BkP/E6B98KF6Pplr3++sU+n7Ic3siFhC5yPT4lWa/t4Crn5Ukn
 RqSt3TQVzW1AA2WJXt1vA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
>> index 911b216..7e44212 100644
>> --- a/drivers/net/ppp/ppp_mppe.c
>> +++ b/drivers/net/ppp/ppp_mppe.c
>> @@ -238,8 +238,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
>>       return (void *)state;
>>
>>       out_free:
>> -        if (state->sha1_digest)
>> -        kfree(state->sha1_digest);
>> +    kfree(state->sha1_digest);
> 
>    Please keep this line aligned to the others.

Can it be that the previous source code contained unwanted space
characters at this place?
Do you want indentation fixes as a separate update step?

Regards,
Markus
