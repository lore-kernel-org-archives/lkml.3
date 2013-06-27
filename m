Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3F0B2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:28:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35504 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab3F0B2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:28:14 -0400
X-Greylist: delayed 971 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 21:28:14 EDT
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
Thread-Topic: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
Thread-Index: AQHObIaE26xHFXGjMk2ppE9gP5LNR5k9UmRpgAAmzNGACz8DooAAFRwA
Date: Thu, 27 Jun 2013 01:10:58 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E4917266843@PRN-MBX01-3.TheFacebook.com>
In-Reply-To: <20130626235521.GH3344@jonmason-lab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.4.130416
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <898EA98A1B25654093B4916714F357F7@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-26_09:2013-06-26,2013-06-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/26/13 4:55 PM, "Jon Mason" <jon.mason@intel.com> wrote:
>Unfortunately, the dma_find_channel model does not led itself to
>optimal usage of the available channels, as it seems to give out the
>same channel.  Adding some randomizer (or other way to spread the
>channel selection over multiple channels) would be greatly
>beneficial.

Right now the allocation scheme is per-cpu.  If you have multiple
submission contexts on different cpus it should use all available channels.

>Alternatively, adding an async_memcpy_mmio function (and perhaps some
>minimal size to use the DMA engine) would provide a solution that
>would work.

It¹s hard.  The size is arch and use specific so it may be best to leave
it up to the client.

>However, dma_find_channel should be sufficient to get NTB use of DMA
>engines out for review.  I'll clean it up and send it out shortly.
>Thanks for the insight.

Cool, I¹ll take a look.


