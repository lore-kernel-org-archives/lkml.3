Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIWDMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 23:12:01 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:18493
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752333AbaIWDL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 23:11:58 -0400
From: "chen.fang@freescale.com" <chen.fang@freescale.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
CC: Shengchao Guo <Shawn.Guo@freescale.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Topic: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Index: AQHPzMEDUFYOXamYk0u51V8bS8XVeJv58E4AgAACowCAAAMwgIAAAZlQgBQmTuA=
Date: Tue, 23 Sep 2014 03:11:52 +0000
Message-ID: <ba228f83093b46d9a6e594a037236198@BY2PR03MB556.namprd03.prod.outlook.com>
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
 <540FF70E.9050203@xs4all.nl>
 <566c6b8349ba4c2ead8f76ff04b52e65@BY2PR03MB556.namprd03.prod.outlook.com>
 <540FFBF1.6060702@xs4all.nl> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB345;
x-forefront-prvs: 0343AC1D30
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(377454003)(51704005)(24454002)(479174003)(189002)(199003)(74662003)(76576001)(64706001)(66066001)(85852003)(31966008)(54356999)(92566001)(106356001)(108616004)(95666004)(120916001)(107046002)(101416001)(99396002)(99286002)(83322001)(46102003)(105586002)(19580395003)(575784001)(19580405001)(93886004)(2201001)(97736003)(83072002)(90102001)(2656002)(74502003)(81542003)(76482002)(76176999)(21056001)(106116001)(50986999)(230783001)(87936001)(86362001)(80022003)(4396001)(85306004)(79102003)(77982003)(33646002)(74316001)(2501002)(20776003)(81342003)(10300001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB345;H:BY2PR03MB556.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans,
Do you have any more comment on this patch?

Best regards,
Fancy Fang

-----Original Message-----
From: Fang Chen-B47543 
Sent: Wednesday, September 10, 2014 3:29 PM
To: 'Hans Verkuil'; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Marek Szyprowski
Subject: RE: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().

On the Freescale imx6 platform which belongs to ARM architecture. The driver is our local v4l2 output driver which is not upstream yet unfortunately.

Best regards,
Fancy Fang

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
Sent: Wednesday, September 10, 2014 3:21 PM
To: Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Marek Szyprowski
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().

On 09/10/14 09:14, chen.fang@freescale.com wrote:
> It is not a theoretically issue, it is a real case that the mapping failed issue happens in 3.14.y kernel but not happens in previous 3.10.y kernel.
> So I need your confirmation on it.

With which driver does this happen? On which architecture?

Regards,

	Hans

> 
> Thanks.
> 
> Best regards,
> Fancy Fang
> 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, September 10, 2014 3:01 PM
> To: Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
> Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; 
> linux-kernel@vger.kernel.org; Marek Szyprowski
> Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
> 
> On 09/10/14 07:28, Fancy Fang wrote:
>> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core 
>> will assign the corresponding offset to the 'boff' field of the 
>> videobuf_buffer for each requested buffer sequentially. Later, user 
>> may call mmap() to map one or all of the buffers with the 'offset'
>> parameter which is equal to its 'boff' value. Obviously, the 'offset'
>> value is only used to find the matched buffer instead of to be the 
>> real offset from the buffer's physical start address as used by 
>> vm_iomap_memory(). So, in some case that if the offset is not zero,
>> vm_iomap_memory() will fail.
> 
> Is this just a fix for something that can fail theoretically, or do you actually have a case where this happens? I am very reluctant to make any changes to videobuf. Drivers should all migrate to vb2.
> 
> I have CC-ed Marek as well since he knows a lot more about this stuff than I do.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
>> ---
>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> index bf80f0f..8bd9889 100644
>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>>  	/* Try to remap memory */
>>  	size = vma->vm_end - vma->vm_start;
>>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> -	retval = vm_iomap_memory(vma, mem->dma_handle, size);
>> +	retval = remap_pfn_range(vma, vma->vm_start,
>> +				 mem->dma_handle >> PAGE_SHIFT,
>> +				 size, vma->vm_page_prot);
>>  	if (retval) {
>>  		dev_err(q->dev, "mmap: remap failed with error %d. ",
>>  			retval);
>>
> 

