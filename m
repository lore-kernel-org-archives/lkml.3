Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3A2P15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:27:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303Ab3A2P1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:27:13 -0500
Message-ID: <5107EA4F.1030209@suse.de>
Date: Tue, 29 Jan 2013 16:27:11 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stefan Weinhuber <WEIN@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 8/9] dasd: Add 'timeout' attribute
References: <1359443521-24670-1-git-send-email-hare@suse.de> <1359443521-24670-9-git-send-email-hare@suse.de> <OF5B1E9925.8182C1D5-ONC1257B02.004C182F-C1257B02.0053F88F@de.ibm.com>
In-Reply-To: <OF5B1E9925.8182C1D5-ONC1257B02.004C182F-C1257B02.0053F88F@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 04:17 PM, Stefan Weinhuber wrote:
> Hannes Reinecke <hare@suse.de> wrote on 2013-01-29 08:12:00:
> [..]
>> +static ssize_t
>> +dasd_timeout_store(struct device *dev, struct device_attribute *attr,
>> +         const char *buf, size_t count)
>> +{
>> +   struct dasd_device *device;
>> +   struct request_queue *q;
>> +   unsigned long val, flags;
>> +
>> +   device = dasd_device_from_cdev(to_ccwdev(dev));
>> +   if (IS_ERR(device))
>> +      return -ENODEV;
>> +
>> +   if ((strict_strtoul(buf, 10, &val) != 0) ||
>> +       val > ULONG_MAX / HZ) {
>> +      dasd_put_device(device);
>> +      return -EINVAL;
>> +   }
>> +   q = device->block->request_queue;
>
> You need to check device->block before using it.
> For alias devices the device->block pointer is NULL, as an alias device
> has no fixed association with a block device.
>
Ah. You live and learn.

Okay, will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
