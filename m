Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaDWCBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:01:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:31941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbaDWCBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:01:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="517660507"
Message-ID: <53571D11.3070808@intel.com>
Date: Wed, 23 Apr 2014 09:53:21 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 7/9] I2C/ACPI: Add i2c ACPI operation region support
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-8-git-send-email-tianyu.lan@intel.com> <20140422113638.GK30677@intel.com>
In-Reply-To: <20140422113638.GK30677@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika:
	Thanks a lot for your review.

On 2014年04月22日 19:36, Mika Westerberg wrote:
>> > +
>> > +	client.adapter = adapter;
>> > +	client.addr = sb->slave_address;
>> > +	client.flags = 0;
> I'm not sure if this is the correct way to use struct i2c_client
> (allocating it from stack and passing forward to functions that might
> expect a real i2c_client structure). It has ->dev and all.

I check all i2c_smbus_xxx helper functions and they are simple wrappers
of i2c_smbus_xfer(). Only adapter, addr and flags of struct client are
used in these functions.

> 
> I'm wondering if you can use i2c_transfer() and i2c_smbus_xfer() here
> instead, passing just the adapter pointer?
> 

Yes, I can do that but this needs to copy all codes of i2c_smbus_xxx
helper function in the i2c-core.c here. This seems duplicated?

-- 
Best regards
Tianyu Lan
