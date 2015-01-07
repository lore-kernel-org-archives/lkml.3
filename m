Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbbAGXFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:05:55 -0500
Received: from mailout.micron.com ([137.201.242.129]:33366 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbbAGXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:05:53 -0500
Message-ID: <54ADBC6E.50301@micron.com>
Date: Wed, 7 Jan 2015 15:08:30 -0800
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>
CC: <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: pass correct seed to integrity metadata generation
 function
References: <54936D1E.3020700@micron.com>
In-Reply-To: <54936D1E.3020700@micron.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21230.002
X-TM-AS-Result: No--4.586700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 04:11 PM, Sam Bradshaw wrote:
> The seed value passed to the blk integrity metadata generation function
> was wrong depending on the device block size (interval) and how many
> blocks comprised the bvec.  This patch converts the seed to 'interval'
> units and increments it correctly for each iteration.  Tested against a
> 4k+8 (w/ type1 PI) sector size.

Any particular objection to this patch?  It would be nice if the kernel
supported PI on block sizes other than just 512 bytes.
