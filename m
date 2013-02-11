Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3BKNOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:14:16 -0500
Received: from multi.imgtec.com ([194.200.65.239]:44832 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab3BKNOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:14:15 -0500
Message-ID: <5118EA3B.9010904@imgtec.com>
Date: Mon, 11 Feb 2013 12:55:23 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>  <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>  <5076AE3B.5040509@imgtec.com> <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com> <5076D360.2010804@imgtec.com>
In-Reply-To: <5076D360.2010804@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_11_12_55_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 11/10/12 15:10, James Hogan wrote:
> On 11/10/12 13:58, James Bottomley wrote:
>> On Thu, 2012-10-11 at 12:32 +0100, James Hogan wrote:
>>> On 11/10/12 11:24, James Bottomley wrote:
>>>> On Thu, 2012-10-11 at 10:15 +0100, James Hogan wrote:
>>>>> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
>>>>> used in struct osd_cdb_head, but it isn't marked as packed. Some
>>>>> architectures will round the struct size up which triggers BUILD_BUG_ON
>>>>> compile errors in osd_initiator.c when the outer structs are unexpected
>>>>> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
>>>>
>>>> What actual problem have you encountered? The structure is {u8[8], u16}
>>>> which is naturally packed on every architecture I know about.  I've even
>>>> built osd_initiator without problem on parisc, which has some of the
>>>> most rigid alignment rules I've seen.
>>>
>>> Hi James,
>>>
>>> The alignment is fine (the offset of the u16 is 8 bytes), but
>>> unfortunately with the metag port of gcc, sizeof(struct
>>> scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
>>> largest data member alignment is only 2 bytes), which is 12 bytes
>>> instead of 10.
>>
>> That sounds to be a bug in your compiler ... it shouldn't be rounding up
>> structure sizes if the structure can fit in 10 bytes.  This isn't
>> happening in any other architecture that I know of (otherwise we'd have
>> had a reported build break).
> 
> This was my initial thought, and I share your feeling that this isn't
> ideal compiler behaviour, however it's pretty much set in stone as part
> of our ABI now. Having talked to one of our compiler folk about it
> here's what he had to say:
>> In GCC 4.2 the following backends have STRUCTURE_SIZE_BOUNDARY set to >=32 which will trigger this behaviour:
>>
>> Alpha+unicos
>> Arm prior to AAPCS
>> Mt
>>
>> This is within standards to my knowledge.

What are the chances of getting this patch accepted? I believe it is
correct and the compiler behaviour is within standards, and hopefully
arch/metag will be merged for v3.9 so without this patch the build of
osd_initiator.c will be broken on an in-tree architecture.

Thanks
James

