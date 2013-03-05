Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3CEAyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:54:55 -0500
Received: from intranet.asianux.com ([58.214.24.6]:1928 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3CEAyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:54:54 -0500
X-Spam-Score: -100.8
Message-ID: <51354247.90602@asianux.com>
Date: Tue, 05 Mar 2013 08:54:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, roger.pau@citrix.com,
        stefano.stabellini@eu.citrix.com, dgdegra@tycho.nsa.gov,
        xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used without
 initialized
References: <512EC22F.5020404@asianux.com> <20130301134316.GA3733@phenom.dumpdata.com>
In-Reply-To: <20130301134316.GA3733@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月01日 21:43, Konrad Rzeszutek Wilk 写道:
> On Thu, Feb 28, 2013 at 10:34:23AM +0800, Chen Gang wrote:
>>
>>   if call xen_vbd_translate failed, the preq.dev will be not initialized.
>>   so use blkif->vbd.pdevice instead (still better to print relative info).
>>
>> additional information:
>>   before commit 01c681d4c70d64cb72142a2823f27c4146a02e63, the value printed
>>   here was bogus, as it was the guest provided value from req->u.rw.handle
>>   rather than the actual device.
> 
> applied with some changes to the description.
> 

  thanks.

>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> Acked-by: Jan Beulich <JBeulich@suse.com>
>> ---
>>  drivers/block/xen-blkback/blkback.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
>> index de1f319..6d1cc3d 100644
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -904,7 +904,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>>  		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=%04x\n",
>>  			 operation == READ ? "read" : "write",
>>  			 preq.sector_number,
>> -			 preq.sector_number + preq.nr_sects, preq.dev);
>> +			 preq.sector_number + preq.nr_sects,
>> +			 blkif->vbd.pdevice);
>>  		goto fail_response;
>>  	}
>>  
>> -- 
>> 1.7.7.6
> 
> 


-- 
Chen Gang

Asianux Corporation
