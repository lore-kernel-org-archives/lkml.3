Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaIJHVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaIJHVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:21:49 -0400
Message-ID: <540FFBF4.9090001@redhat.com>
Date: Wed, 10 Sep 2014 09:21:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org>
In-Reply-To: <20140909152730.GA17882@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/09/2014 05:27 PM, Christoph Hellwig wrote:
> On Tue, Sep 09, 2014 at 11:15:24AM +0200, Hans de Goede wrote:
>> Taking the uas.c file from 3.17, and building it for 3.16 restores
>> the use of tcq (debugged by adding a printk blk_rq_tagged + request->tag).
>>
>> So either uas is doing something wrong which happened to work in
>> 3.16, or something has broken in 3.17.
>>
>> I've already added debug printk-s of scsi_device->tagged_supported,
>> queue_depth, ordered_tags and simple_tags and those all look good
>> (1, 29, 1, 1).
>>
>> I've also tried setting disable_blk_mq and that does not help.
>>
>> Any hints to help debugging this further (other then a bisect) are
>> appreciated. If no-one has any smart ideas I guess I'll end up doing
>> a full bisect.
> 
> scsi-mq isn't enabled by default, so setting disable_blk_mq should
> indeed not make a difference.
> 
> One interesting thing with uas is that it uses scsi_init_shared_tag_map,
> which only few drivers do.
> 
> Can you apply a debug patch like the one below and see if that helps to
> poinpoint down the issue?

I've applied the patch, this results in the following new dmesg output
when using uas:

[  120.602632] initialized host-wide tag map!

Thank you for looking into this.

Regards,

Hans
