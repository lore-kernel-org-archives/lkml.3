Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3COBqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:46:03 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49971 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3COBqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:46:02 -0400
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=C56BoFkcj+OI1kjAe8jE5A==:17 a=MtVMNMWb1ewA:10 a=mBswGg73kkcA:10 a=xAKztkj4arMA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=0-VSvy7d93UA:10 a=QfKxxUxMAAAA:8 a=hyx0zNJKdg0iJIY76R8A:9 a=wPNLvfGTeEIA:10 a=C56BoFkcj+OI1kjAe8jE5A==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 142.196.87.46
Message-ID: <51427D57.7080702@ubuntu.com>
Date: Thu, 14 Mar 2013 21:45:59 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: cleanup partitions when detaching loop device
References: <1362336553-16880-1-git-send-email-psusi@ubuntu.com> <20130314150709.056aa4de5fadf3a5e94103d4@linux-foundation.org>
In-Reply-To: <20130314150709.056aa4de5fadf3a5e94103d4@linux-foundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/14/2013 06:07 PM, Andrew Morton wrote:
> huh.  What is the user-visible effect of this bug?  Just a memory
> leak or something more serious?

Not serious, but user-visible in that the partition devnodes still
show up after detaching the backing file, and I think the partitions
remained in place after attaching a new file even though it had
different or no partitions at all.

> scripts/checkpatch.pl is your friend.

Oops.  I see you pushed a patch fixing up the brace position and
breaking the long line.  Did you want me to squash it and resubmit, or
just sign off on it?  If the latter, consider it signed off.

> Can you please suggest a code comment which we can slip in here to
> tell readers what's going on and why we're doing this?

How about "Remove all partitions, since BLKRRPART won't remove user
added partitions when max_part=0"?

>> +		struct disk_part_iter piter; +		struct hd_struct *part; + +
>> mutex_lock_nested(&bdev->bd_mutex, 1); +
>> invalidate_partition(bdev->bd_disk, 0); +
>> disk_part_iter_init(&piter, bdev->bd_disk,
>> DISK_PITER_INCL_EMPTY); +		while ((part =
>> disk_part_iter_next(&piter))) +			delete_partition(bdev->bd_disk,
>> part->partno); +		disk_part_iter_exit(&piter); +
>> mutex_unlock(&bdev->bd_mutex); +	}
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJRQn1XAAoJEJrBOlT6nu75QIEIAIM4skpZoKWYzAYXCK84JjP2
7Z0toyWfpQ63ku7grFPMST8wpGrsq31zcwa7zvya2Tg0ivi0vHOZmw0QBVic3mw0
Ce88iVkCDQSoASwPdHRLwNLj7Lj/cvHkwqZIHbDXR5u15v1sr3NTrCDMP33kZlPi
Z8TbX+3fTTMYriYXUOI8fmqnC+d1gj8w+fsNNAB23/mVgN6ed9uGMQqEQjXGQOnQ
By9R7dD5SZ9hqstLBSCvochBVfNjWm2rMtKTnixcY1qTDGCLWZ2sUpxns6WTjAZl
lWL/S80kt+sbpkQorXWWDZJAvyRhQny4703rwPRhzgMWPDY7qJkn465tDT4S/ic=
=3/XD
-----END PGP SIGNATURE-----
