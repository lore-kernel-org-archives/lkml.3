Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbbAHGY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:24:28 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:39145 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbbAHGY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:24:27 -0500
From: =?gb2312?B?Q2h1bnlhbiBaaGFuZyAo1cW0utHeKQ==?= 
	<Chunyan.Zhang@spreadtrum.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        =?gb2312?B?TWFyayBZYW5nICjR7tPAu9Qp?= <Mark.Yang@spreadtrum.com>,
        =?gb2312?B?V2VpIFFpYW8gKMfHzrAp?= <Wei.Qiao@spreadtrum.com>,
        =?gb2312?B?R2VuZyBSZW4gKMjO4tkp?= <Geng.Ren@spreadtrum.com>,
        =?gb2312?B?T3Jzb24gWmhhaSAotdS+qSk=?= <Orson.Zhai@spreadtrum.com>,
        =?gb2312?B?WmhpemhvdSBaaGFuZyAo1cXWztbeKQ==?= 
	<Zhizhou.Zhang@spreadtrum.com>,
        =?gb2312?B?S2UgV2FuZyAozfW/xik=?= <Ke.Wang@spreadtrum.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>, "Tejun Heo" <tj@kernel.org>
Subject: RE: [PATCH] kernel: async: Fixed the wrong waitting condition of
 wait_event
Thread-Topic: [PATCH] kernel: async: Fixed the wrong waitting condition of
 wait_event
Thread-Index: AQHQKtuHfaC3GIuPaUGx5xFMzLOA6Zy1u7kA
Date: Thu, 8 Jan 2015 06:20:35 +0000
Message-ID: <4fdc864411a24125b49ca66989011928@SHMBX02.spreadtrum.com>
References: <async>
	<1420428935-30385-1-git-send-email-chunyan.zhang@spreadtrum.com>,<20150107163915.50a71131faf74e0f75562137@linux-foundation.org>
In-Reply-To: <20150107163915.50a71131faf74e0f75562137@linux-foundation.org>
Accept-Language: en-US, zh-CN, en-HK
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.67.164]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-MAIL: SHSQR01.spreadtrum.com t086Knf2058981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t086OXqw028941

Hi, Andrew

Could you give us the test log including the runtime problems you've got?

Thank you so much.


Best regards
Chunyan

On Mon, 5 Jan 2015 11:35:35 +0800 Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:

> This patch changes the waitting condition of wait_event in the
> function 'async_synchronize_cookie_domain'.
>
> This function waits until all asynchronous function calls for the certain
> domain have been done.
>
> But, the function 'lowest_in_progress' returns the lowest *pending*
> entry's cookie.
>
> So we should make sure that the return value of lowest_in_progress(domain)
> must be larger than @cookie.

I'm having runtime problems with this.  Twice the kernel silently hangs
late in initcalls and the third time I got a great stream of oopses.

I'll drop it.  Hopefully you'll be able to work through the bug with
Arjan and Tejun.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
