Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaKLV3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:29:00 -0500
Received: from mout.web.de ([212.227.17.11]:58539 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbaKLV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:28:58 -0500
Message-ID: <5463D109.4020702@users.sourceforge.net>
Date: Wed, 12 Nov 2014 22:28:41 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 1/2] staging: rtl8188eu: Deletion of unnecessary checks
 before three function calls
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien> <5463C10D.6020409@users.sourceforge.net> <5463C22B.7060405@users.sourceforge.net> <20141112211815.GJ6749@mwanda>
In-Reply-To: <20141112211815.GJ6749@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:xJYGpKLUHXAggGkDtebylUPPafuaBw48WakIPiMYP2gpZf0jEMZ
 2i5CcR1OE+RydYbzfapO8mOIyRF2VIRO7xMoV6Qf+N7ltDxUbseBMgXEuMrIcOZUWEeYKhy
 XHrJUQWrPgB/Tj1FbVkqu4rpP4CJ4Q17QQ9Pl8vPsGk+CMLCyKmqPZtmevmgoXF1/6nTiUH
 1M4gCVNVv9JYG2zMHKDTg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -487,8 +488,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
>>  	DBG_88E("+r871xu_dev_remove, hw_init_completed=%d\n",
>>  		if1->hw_init_completed);
>>  	rtw_free_drv_sw(if1);
>> -	if (pnetdev)
>> -		rtw_free_netdev(pnetdev);
>> +	rtw_free_netdev(pnetdev);
> 
> I still feel that hiding the if statement inside the function call makes
> the code more subtle and it is a bad harmful thing to do.

I find your feedback interesting.


> This is especially true if you have trained yourself to know that
> free_netdev() can't accept NULL pointers.

Do you need to adjust your concerns a bit over time when function variants
provide a corresponding safety check in their implementations?

Regards,
Markus
