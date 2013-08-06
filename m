Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3HFVil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:38:41 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:50637 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3HFVij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:38:39 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-c4-52016cdd4513
From: Shuah Khan <shuah.kh@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-topic: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-index: Ac6SyFcWUhE6FBeWT/iSf5cAZjp8ng==
Date: Tue, 06 Aug 2013 21:38:36 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175A68C@sisaex02sj>
References: <Pine.LNX.4.44L0.1308061719440.930-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+wr+69HMYgg80/mSwu75rDZnH31FE2
	i/6FvUwWE35fYHNg8Zh99wejx6PFLYweK1Z/Z/f4vEkugCWKyyYlNSezLLVI3y6BK2NO0xu2
	gqt8FR/n32dsYHzP3cXIySEhYCJxbPduNghbTOLCvfVANheHkMAyRonLBz8zQji9TBJvl8I4
	8xklVlx6yAjSwiagLvH59Q52EFtEQEtic9NLZpAiZoElQO3npoIlhAUcJU4u+80KUeQk8fDg
	aagGPYnHs6awgNgsAqoS/SuXg9m8AvYSJ7+tZwaxhQS8Jdb97wC7jxHovu+n1jCB2MwC4hLN
	rTdZIO4WkFiy5zwzhC0q8fLxP6BdHEC2osT21VYQ5VoS63ceh2rVlnjy7gIrxCpBiR+T77FM
	YBSbhWTqLCQts5C0zELSsoCRZRWjWGlxckFxUnpqhaFecWJucWleul5yfu4mRkisVe1gvPPV
	5hCjAAejEg/vBQnGICHWxLLiytxDjBIczEoivD4gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyp
	RR/aHm6RWBYnuOZsR50/e45RFvcd8dPttuki4rXGX6O277fnXPf6ztIsLTbZVq7SxbriHN3H
	t2svll3Hu/nWE5ufZSYmc/c5yPycEfw6bnGKxt2nm9ONoz2OKK6+I7W7UG3he+Z+6aQ040mP
	Lx1SjI/5oMHW6LroxhfvMGPOWTnmUf5rXJVYijMSDbWYi4oTAWO2uJyTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 03:22 PM, Alan Stern wrote:
> On Tue, 6 Aug 2013, Shuah Khan wrote:
>
>> With the dev_pm_ops model, drivers have to provide interfaces for each
>> one of these states.
>
> No, they don't.  They can leave out interfaces if they want.

Yes. Agreed. There is no need to provide each and every interface. Only 
the ones driver wishes to handle.

>
>>   In this case, there will be a conflict since
>> pm_op() treats this state as freeze where as the driver wants to do
>> treat it as a suspend/hibernate. In the case of legacy pm_ops, state is
>> passed in as a parameter and driver could take special action if need
>> be, based on the state, however in dev_pm_ops model, state is not passed
>> in. Instead it is handled with state specific pm_ops interfaces.
>>
>> For example, if this driver were to be converted to dev_pm_ops, it would
>> require a freeze interface which will call sl811h_bus_suspend(). Once
>> that is done, PM_EVENT_PRETHAW will be mapped to freeze() ops and
>> sl811h_bus_suspend() will be called instead of port_power(sl811, 0);
>>
>> What I am getting at is, there is no provision to handle the special
>> case for PM_EVENT_PRETHAW like in the case of this driver when using
>> dev_pm_ops.
>
> Okay.  So what?
>

I am exploring to see if there is a deficiency in dev_pm_ops 
infrastructure that needs addressing. Based on this example, there is a 
need for a way to allow drivers that want to do something state specific 
that is different from the defined framework if need be.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
