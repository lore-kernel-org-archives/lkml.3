Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbbA2HIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:08:39 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51326 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbA2HIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:08:37 -0500
Date: Thu, 29 Jan 2015 16:08:35 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150129070835.GD2555@swordfish>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
 <20150128233343.GC4706@blaptop>
 <CAHqPoqKZFDSjO1pL+ixYe_m_L0nGNcu04qSNp-jd1fUixKtHnw@mail.gmail.com>
 <20150129020139.GB9672@blaptop>
 <20150129022241.GA2555@swordfish>
 <20150129052827.GB25462@blaptop>
 <20150129060604.GC2555@swordfish>
 <20150129063505.GA32331@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129063505.GA32331@blaptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/29/15 15:35), Minchan Kim wrote:
>
> As you told, the data was not stable.
>
yes. fread test was always slower, and the rest was mostly slower.


> Anyway, when I read down_read implementation, it's one atomic instruction.
> Hmm, it seems te be better for srcu_read_lock which does more things.
>
srcu looks havier, agree.

> But I guessed most of overhead are from [de]compression, memcpy, clear_page
> That's why I guessed we don't have measurable difference from that.
> What's the data pattern if you use iozone?

by "data pattern" you mean usage scenario? well, I usually use zram for
`make -jX', where X=[4..N]. so N concurrent read-write ops scenario.

	-ss

> I guess it's really simple pattern compressor can do fast. I used /dev/sda
> for dd write so more realistic data. Anyway, if we has 10% regression even if
> the data is simple, I never want to merge it.
> I will test it carefully and if it turns out lots regression,
> surely, I will not go with this and send the original patch again.
