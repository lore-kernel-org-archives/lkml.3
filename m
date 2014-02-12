Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaBLNmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:42:46 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:14063 "EHLO
	smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:42:42 -0500
X-IronPort-AV: E=Sophos;i="4.95,832,1384300800"; 
   d="scan'208";a="78966562"
Message-ID: <52FB7A46.7020801@amazon.de>
Date: Wed, 12 Feb 2014 14:42:30 +0100
From: "Egger, Christoph" <chegger@amazon.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Rushton <mrushton7@yahoo.com>,
        =?UTF-8?B?Um9nZXIgUGF1IE1vbm5l?= =?UTF-8?B?IOKAjuKAjg==?= 
	<roger.pau@citrix.com>
CC: =?UTF-8?B?SWFuIENhbXBiZWxsIOKAjg==?= <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mrushton@amazon.com" <mrushton@amazon.com>,
        =?UTF-8?B?RGF2aWQgVnJhYmVsIA==?= =?UTF-8?B?4oCO4oCO4oCO?= 
	<david.vrabel@citrix.com>,
        "msw@amazon.com" <msw@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        =?UTF-8?B?Qm9yaXMgT3N0cm92c2t5IOKAjg==?= 
	<boris.ostrovsky@oracle.com>,
        "aliguori@amazon.com" <aliguori@amazon.com>
Subject: Re: [Xen-devel] [PATCH v2 2/4] xen-blkback: fix memory leaks
References: <1391742906.53011.YahooMailNeo@web122601.mail.ne1.yahoo.com>
In-Reply-To: <1391742906.53011.YahooMailNeo@web122601.mail.ne1.yahoo.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.14 04:15, Matthew Rushton wrote:
> On 04/02/14 10:26, Roger Pau Monne wrote:
>> I've at least identified two possible memory leaks in blkback, both
>> related to the shutdown path of a VBD:
>> 
>> - blkback doesn't wait for any pending purge work to finish before
>>   cleaning the list of free_pages. The purge work will call
>>   put_free_pages and thus we might end up with pages being added to
>>   the free_pages list after we have emptied it. Fix this by making
>>   sure there's no pending purge work before exiting
>>   xen_blkif_schedule, and moving the free_page cleanup code to
>>   xen_blkif_free.
>> - blkback doesn't wait for pending requests to end before cleaning
>>   persistent grants and the list of free_pages. Again this can add
>>   pages to the free_pages list or persistent grants to the
>>   persistent_gnts red-black tree. Fixed by moving the persistent
>>   grants and free_pages cleanup code to xen_blkif_free.
>> 
>> Also, add some checks in xen_blkif_free to make sure we are cleaning
>> everything.
> 
> Tested-by: Matt Rushton <mrushton@amazon.com>
> Reviewed-by: Matt Rushton <mrushton@amazon.com>

Tested-by: Christoph Egger <chegger@amazon.de>
Reviewed-by: Christoph Egger <chegger@amazon.de>

Christoph

