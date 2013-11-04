Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3KDLZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:25:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18380 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3KDLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:25:38 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-8b-527784311e3c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
Date: Mon, 04 Nov 2013 12:25:28 +0100
Message-id: <6263345.NhfL3kvMZj@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5273D80F.5070205@kernel.dk>
References: <20131101135931.GA22903@redhat.com>
 <20131101162823.GB23501@redhat.com> <5273D80F.5070205@kernel.dk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAV3DlvIgg19PpC1W3+1nszg9YRGT
	xfxJTSwWl3fNYbNo2/iV0YHVY+mHVcwem1doeVw+W+rxft9VNo/Pm+QCWKO4bFJSczLLUov0
	7RK4MrYf5yv4y1Px4utBlgbGNVxdjJwcEgImEs1z1jJB2GISF+6tZ+ti5OIQEljEKLGkeT4b
	SEJIoIVJYvtJFhCbTcBKYmL7KkYQW0RAQaLn90qwBmaBiYwS7TdeghUJC7hJXN3ykhnEZhFQ
	lVh7+jSYzSugKbF8zRewGlEBT4kd21eCLeAEir/9NZkRYlmRRN/tKawQ9YISPybfA6tnFpCX
	2Ld/KiuErSOxv3Ua2wRGgVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOBgfia9g3FVg8UhRgEORiUeXonLZUFCrIllxZW5hxglOJiVRHhXFJUHCfGmJFZWpRblxxeV
	5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBc67T5PevbM2mCjG/llVbWVJov
	VjnHq3xVQaM0qaDexbG/1JPptmlHYMSZLg3n2zlKWud7Nq89uJGpU8p0fv5XH2+TpeemMN7j
	Xdq6L4bT0OjS7fkXFFpia2bYJDbdm9xzTCHf/uqTiW9fvpo5uz+2zEU0nm/i/NDVxypSjjCn
	Z7qIijPLpyuxFGckGmoxFxUnAgApkkawYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, November 01, 2013 10:34:23 AM Jens Axboe wrote:
> On 11/01/2013 10:28 AM, Mike Snitzer wrote:
> > On Fri, Nov 01 2013 at 12:02pm -0400,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 11/01/2013 09:50 AM, Christoph Hellwig wrote:
> >>> On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
> >>>> All the bi_sector ones are low hanging fruit, but the conversion for
> >>>> skd_preop_sg_list_bio()'s bio_vec code is more involved.
> >>>>
> >>>> Kent, any chance you could crank through it?
> >>>>
> >>>> If not I can come back to trying to fix this later.. but I'm working
> >>>> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
> >>>> 'for-next'.
> >>>
> >>> The right thing for 3.13 is to rip out the bio base code path, and
> >>> for 3.14 to convert it to blk-mq.
> >>
> >> It is. I will kill it.
> > 
> > I just cranked through it.. hope this helps (think I got everything but
> > may have missed something):
> 
> You lost out, I committed it 20 min ago :-0
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=1d36f7a5fb577afaaead6c5e2fc8e01e0c95235d

I did the complete bio path removal a month ago in my skd patchset:

	https://lkml.org/lkml/2013/9/30/279

and the change has been agreed on by Ramprasad C from STEC:

	https://lkml.org/lkml/2013/10/3/339

> Looks like you missed some of the skd_device removal, while I neglected
> killing bio/start_time in the skd_request_context.

Could you please apply my patchset before doing new work on skd driver?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

