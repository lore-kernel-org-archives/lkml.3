Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaKFSPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:15:40 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62942 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKFSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:15:35 -0500
Message-ID: <545BBAC4.3000503@kernel.dk>
Date: Thu, 06 Nov 2014 11:15:32 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Friesen <chris.friesen@windriver.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com> <yq1fvdwb3lq.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1fvdwb3lq.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-06 11:12, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:
>
> Chris> That'd work, but is it the best way to go?  I mean, I found one
> Chris> report of a similar problem on an SSD (model number unknown).  In
> Chris> that case it was a near-UINT_MAX value as well.
>
> My concern is still the same. Namely that this particular drive happens
> to be returning UINT_MAX but it might as well be a value that's entirely
> random. Or even a value that is small and innocuous looking but
> completely wrong.
>
> Chris> The problem with the blacklist is that until someone patches it,
> Chris> the drive is broken.  And then it stays blacklisted even if the
> Chris> firmware gets fixed.
>
> Well, you can manually blacklist in /proc/scsi/device_info.
>
> Chris> I'm wondering if it might not be better to just ignore all values
> Chris> larger than X (where X is whatever we think is the largest
> Chris> conceivable reasonable value).
>
> The problem is that finding that is not easy and it too will be a moving
> target.

Didn't check, but assuming the value is the upper 24 bits of 32. If so, 
might not hurt to check for as 0xfffffe00 as an invalid value.

-- 
Jens Axboe

