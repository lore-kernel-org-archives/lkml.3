Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935815Ab3DQREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:04:54 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:20094 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3DQREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:04:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,494,1363132800"; 
   d="scan'208";a="3659627"
Message-ID: <516ED633.3040205@citrix.com>
Date: Wed, 17 Apr 2013 19:04:51 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 7/7] xen-block: implement indirect descriptors
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com> <1364382643-3711-8-git-send-email-roger.pau@citrix.com> <20130409184923.GA4978@phenom.dumpdata.com> <516C3264.3050409@citrix.com> <20130417142554.GG21378@phenom.dumpdata.com>
In-Reply-To: <20130417142554.GG21378@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/13 16:25, Konrad Rzeszutek Wilk wrote:
>>> Perhaps the xen-blkfront part of the patch should be just split out to make
>>> this easier?
>>>
>>> Perhaps what we really should have is just the 'max' value of megabytes
>>> we want to handle on the ring.
>>>
>>> As right now 32 ring requests * 32 segments = 4MB.  But if the user wants
>>> to se the max: 32 * 4096 = so 512MB (right? each request would handle now 16MB
>>> and since we have 32 of them = 512MB).
>>
>> I've just set that to something that brings a performance benefit
>> without having to map an insane number of persistent grants in blkback.
>>
>> Yes, the values are correct, but the device request queue (rq) is only
>> able to provide read requests with 64 segments or write requests with
>> 128 segments. I haven't been able to get larger requests, even when
>> setting this to 512 or higer.
> 
> What are you using to drive the requests? 'fio'?

Yes, I've tried fio with several "bs=" values, but it doesn't seem to
change the size of the underlying requests. Have you been able to get
bigger requests?
