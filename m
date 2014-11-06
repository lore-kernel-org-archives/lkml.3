Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaKFRpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:45:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:43832 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKFRpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:45:23 -0500
Message-ID: <545BB3AB.8070409@windriver.com>
Date: Thu, 6 Nov 2014 11:45:15 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com> <yq1k338b5d5.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1k338b5d5.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.119.46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 11:34 AM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:
>
> Chris> Perhaps the ST900MM0026 should be blacklisted as well?
>
> Sure. I'll widen the net a bit for that Seagate model.

That'd work, but is it the best way to go?  I mean, I found one report 
of a similar problem on an SSD (model number unknown).  In that case it 
was a near-UINT_MAX value as well.

The problem with the blacklist is that until someone patches it, the 
drive is broken.  And then it stays blacklisted even if the firmware 
gets fixed.

I'm wondering if it might not be better to just ignore all values larger 
than X (where X is whatever we think is the largest conceivable 
reasonable value).

Chris
