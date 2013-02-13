Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab3BMPtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:49:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010Ab3BMPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:49:18 -0500
Message-ID: <511BB5EA.7020007@redhat.com>
Date: Wed, 13 Feb 2013 16:48:58 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 00/14] Corrections and customization of the SG_IO command
 whitelist (CVE-2012-4542)
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <511B4F95.1050404@redhat.com> <511BB2AD.4000605@interlog.com>
In-Reply-To: <511BB2AD.4000605@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/02/2013 16:35, Douglas Gilbert ha scritto:
>>
>> Ping? I'm not even sure what tree this should host these patches...
> 
> You are whitelisting SCSI commands so obviously the SCSI tree
> and the patch spills over into the block tree.

Yeah, an Acked-by is in order but it's not clear from whom and for whom.

> Can't see much point in ack-ing the sg changes since most
> of the action is at higher levels.
> 
> The question I have is what existing code will this change
> break (and will I being getting emails from peeved
> developers)?

An unlikely situation is that a vendor-specific command in the "low"
range (i.e. not 0xc0..0xff) conflicted with an MMC command, so it
happened to be enabled.  That will now break, but only if executed
without CAP_SYS_RAWIO.

Nothing will change for programs executed with CAP_SYS_RAWIO.

I have not disabled any standards-defined command that used to be
enabled, and on the contrary I enabled a few of them, so this could
potentially lead to less emails from peeved developers, too.

> Is 8 lines of documentation changes enough? My guess is
> that SG_IO ioctl pass-through users will be tripped up
> and it won't be obvious to them to look at
>     Documentation/block/queue-sysfs.txt
> for enlightenment; especially if they are using a char
> device node from the bsg, sg or st drivers to issue SG_IO.

The command whitelist was not documented before.  It's quite likely that
any documentation except the code itself would not be updated the next
time the whitelist is touched.

Paolo
