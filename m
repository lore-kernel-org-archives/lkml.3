Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab3ICSid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:38:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3ICSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:38:32 -0400
Message-ID: <52262CA4.2030902@kernel.dk>
Date: Tue, 03 Sep 2013 12:38:28 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Milburn <dmilburn@redhat.com>
CC: Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH] mtip32xx: Add SRSI support
References: <518BE87F.3080201@micron.com> <52262C8F.30107@redhat.com>
In-Reply-To: <52262C8F.30107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 12:38 PM, David Milburn wrote:
> Asai Thambi S P wrote:
>> This patch add support for SRSI(Surprise Removal Surprise Insertion).
>>
>> Approach:
>> ---------
>> Surprise Removal:
>> -----------------
>> On surprise removal of the device, gendisk, request queue, device
>> index, sysfs
>> entries, etc are retained as long as device is in use - mounted
>> filesystem,
>> device opened by an application, etc. The service thread breaks out of
>> the main
>> while loop, waits for pci remove to exit, and then waits for device to
>> become
>> free. When there no holders of the device, service thread cleans up
>> the block
>> and device related stuff and returns.
>>
>> Surprise Insertion:
>> -------------------
>> No change, this scenario follows the normal pci probe() function flow.
>>
>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>> ---
>>  drivers/block/mtip32xx/mtip32xx.c |  453
>> ++++++++++++++++++++++---------------
>>  drivers/block/mtip32xx/mtip32xx.h |   18 +-
>>  2 files changed, 289 insertions(+), 182 deletions(-)
>>
> 
> Hi Jens,
> 
> Will you be considering this patch for 3.12?

Yep, it will go in this merge window.

-- 
Jens Axboe

