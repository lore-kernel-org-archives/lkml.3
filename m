Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaCFLWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:22:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaCFLWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:22:34 -0500
Message-ID: <53185A79.9010206@suse.de>
Date: Thu, 06 Mar 2014 12:22:33 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <famz@redhat.com>,
        linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: Change sense buffer size to 252
References: <1394095660-15075-1-git-send-email-famz@redhat.com> <53184962.3080100@redhat.com>
In-Reply-To: <53184962.3080100@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 11:09 AM, Paolo Bonzini wrote:
> Il 06/03/2014 09:47, Fam Zheng ha scritto:
>> According to SPC-4, section 4.5.2.1, 252 is the limit of sense
>> data. So
>> increase the value.
>>
>> Signed-off-by: Fam Zheng <famz@redhat.com>
>> ---
>>  include/linux/virtio_scsi.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/virtio_scsi.h
>> b/include/linux/virtio_scsi.h
>> index 4195b97..a437f7f 100644
>> --- a/include/linux/virtio_scsi.h
>> +++ b/include/linux/virtio_scsi.h
>> @@ -28,7 +28,7 @@
>>  #define _LINUX_VIRTIO_SCSI_H
>>
>>  #define VIRTIO_SCSI_CDB_SIZE   32
>> -#define VIRTIO_SCSI_SENSE_SIZE 96
>> +#define VIRTIO_SCSI_SENSE_SIZE 252
>>
>>  /* SCSI command request, followed by data-out */
>>  struct virtio_scsi_cmd_req {
>>
> 
> Hi Fam, how did you test this?
> 
Is there a specific reason _not_ to use the linux default?
The SCSI stack typically limits the sense code to
SCSI_SENSE_BUFFERSIZE, so using other values have a
limited sense.
Literally :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
