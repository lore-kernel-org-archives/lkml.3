Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3LDILp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:11:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52856 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3LDILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:11:43 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-99-529ee3bed50d
Message-id: <1386144643.2417.148.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: refactor bio-related operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Wed, 04 Dec 2013 17:10:43 +0900
In-reply-to: <001101cef0b6$562766e0$027634a0$@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
 <1385972847.2417.113.camel@kjgkr> <001101cef0b6$562766e0$027634a0$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY919j+cFGXR1c1n8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY9mE5ywF
	GzgqTk3YzdzA2MTWxcjBISFgInHoY1YXIyeQKSZx4d56oDAXh5DAMkaJV1desUAkTCTOf5nE
	CmILCUxnlLi3wxKi6BWjxLLVjxhBErwCuhLLniwHKxIW8JCYeaWfEWQBm4C2xOb9BhC9ihJv
	998FKxERUJL4NX8RK8gcZoGFjBLP90xkA0mwCKhKLDneDbaYU8BK4sfph+wQy2YySqw/9Rps
	Gb+AqMThhduZQWxmAXWJSfMWMUNcqiSxu72THSIuL7F5zVtmiOMEJX5MvscCMkhC4BS7RMec
	U4wQ2wQkvk0+xAIJClmJTQeg5khKHFxxg2UCo8QsJCtmIRk7C8nYBYzMqxhFUwuSC4qT0osM
	9YoTc4tL89L1kvNzNzFCoq93B+PtA9aHGJOBVk5klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlp
	wkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEZP2rq4J7fgvZ3q/g2HOgpXy63T
	+a15aGGhTVLKSvszcdtffhX5uGOWSbuyY0Ttek6R+rrLVtwc/oaOth8lFnEE31Xxckla1VB/
	qfXLU8W26t6Qn996zG6r3l9lPtNz6k0llwkGN45dZQ5rUVW4Ns2tf0Unj+G+2CnrplgdZHA+
	UTX510zTG0osxRmJhlrMRcWJAKQ9AzzUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd19j+cFGZz7y2rxv+kjm8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoxlE56zFGzgqDg1YTdzA2MTWxcjJ4eEgInE+S+TWCFsMYkL99aD
	xYUEpjNK3Nth2cXIBWS/YpRYtvoRI0iCV0BXYtmT5WANwgIeEjOv9APFOTjYBLQlNu83gOhV
	lHi7/y5YiYiAksSv+YtYQeYwCyxklHi+ZyLYAhYBVYklx7tZQGxOASuJH6cfskMsm8kosf7U
	a7Bl/AKiEocXbmcGsZkF1CUmzVvEDHGpksTu9k52iLi8xOY1b5khjhOU+DH5HssERqFZSFpm
	ISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg6H4mtYNxZYPFIUYBDkYlHt4E
	znlBQqyJZcWVuYcYJTiYlUR4FR8ChXhTEiurUovy44tKc1KLDzEmA703kVlKNDkfmHjySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGxscG5w0pOydZG9qO0
	g9yS+7sFJzOfNYhrurFQP23bkUSboPbJS9e4Oj95cuZUyIL1Z+pfTZvosEG260rG/bWBGZ9K
	FkqEcGw9p/f1es2HzJZHMt7+U59yv26UN0x/w5LspxF0+nY3j4dZuA3L9Io3xlsOv3QqbVXy
	Y/619KBz24LKRUcvVGorsRRnJBpqMRcVJwIAGvGc+zIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > +	if (btype == META)
> > +		rw |= REQ_META;
> > +
> > +	if (is_read_io(rw)) {
> > +		if (sync)
> > +			rw |= READ_SYNC;
> > +		submit_bio(rw, io->bio);
> > +		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
> > +		io->bio = NULL;
> > +		return;
> > +	}
> > +
> > +	if (sync)
> > +		rw |= WRITE_SYNC;
> 
> rw = WRITE_SYNC; ?

No, since it removes the REQ_META.
See above.

> 
> > +	if (type >= META_FLUSH)
> > +		rw |= WRITE_FLUSH_FUA;
> 
> rw = WRITE_FLUSH_FUA; ?
> 
> > +
> > +	/*
> > +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
> > +	 * this metadata bio for FS consistency.
> > +	 */
> > +	if (type == META_FLUSH) {
> > +		DECLARE_COMPLETION_ONSTACK(wait);
> > +		io->bio->bi_private = &wait;
> > +		submit_bio(rw, io->bio);
> > +		wait_for_completion(&wait);
> > +	} else {
> > +		submit_bio(rw, io->bio);
> > +	}
> > +	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
> > +	io->bio = NULL;
> > +}
> 
> [snip]
> 
> Thanks,
> Yu
> 

-- 
Jaegeuk Kim
Samsung

