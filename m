Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaJCVSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:18:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59993 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaJCVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:18:01 -0400
Message-ID: <542F1284.2070702@kernel.dk>
Date: Fri, 03 Oct 2014 15:17:56 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
CC: tytso@mit.edu, gmazyland@gmail.com, agk@redhat.com, mpatocka@redhat.com
Subject: Re: [PATCH] block: disable entropy contributions from nonrot devices
References: <1412295074-4984-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <1412295074-4984-1-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-02 18:11, Mike Snitzer wrote:
> Introduce queue_flags_set_nonrot_clear_add_random() and convert all
> block drivers that set QUEUE_FLAG_NONROT over to using it instead.
>
> Historically, all block devices have automatically made entropy
> contributions.  But as previously stated in commit e2e1a148 ("block: add
> sysfs knob for turning off disk entropy contributions"):
>      - On SSD disks, the completion times aren't as random as they
>        are for rotational drives. So it's questionable whether they
>        should contribute to the random pool in the first place.
>      - Calling add_disk_randomness() has a lot of overhead.
>
> There are more reliable sources for randomness than non-rotational block
> devices.  From a security perspective it is better to err on the side of
> caution than to allow entropy contributions from unreliable "random"
> sources.

Don't add a special function for this, just use the flag clear/set 
functions for both.

-- 
Jens Axboe

