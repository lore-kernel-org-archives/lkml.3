Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3A2LlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:41:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3A2LlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:41:01 -0500
Message-ID: <5107B54C.5090602@suse.de>
Date: Tue, 29 Jan 2013 12:41:00 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        Stefan Weinhuber <wein@de.ibm.com>
Subject: Re: [PATCH 8/9] dasd: Add 'timeout' attribute
References: <1359443521-24670-1-git-send-email-hare@suse.de> <1359443521-24670-9-git-send-email-hare@suse.de> <20130129113627.GB5984@osiris>
In-Reply-To: <20130129113627.GB5984@osiris>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 12:36 PM, Heiko Carstens wrote:
> On Tue, Jan 29, 2013 at 08:12:00AM +0100, Hannes Reinecke wrote:
>> This patch adds a 'timeout' attibute to the DASD driver.
>> When set to non-zero, the blk_timeout function will
>> be enabled with the timeout specified in the attribute.
>> Setting 'timeout' to '0' will disable block timeouts.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> [...]
>
>> +static ssize_t
>> +dasd_timeout_store(struct device *dev, struct device_attribute *attr,
>> +		   const char *buf, size_t count)
>> +{
>> +	struct dasd_device *device;
>> +	struct request_queue *q;
>> +	unsigned long val, flags;
>> +
>> +	device = dasd_device_from_cdev(to_ccwdev(dev));
>> +	if (IS_ERR(device))
>> +		return -ENODEV;
>> +
>> +	if ((strict_strtoul(buf, 10, &val) != 0) ||
>> +	    val > ULONG_MAX / HZ) {
>
> Probably this should be UINT_MAX instead of ULONG_MAX, otherwise it
> might overflow since blk_queue_rq_timeout(...) expects only an
> unsigned int.
>
Ok, will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
