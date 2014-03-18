Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaCRJnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:43:10 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53202 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754552AbaCRJnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:43:07 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'behanw@converseincode.com'" <behanw@converseincode.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "pablo@netfilter.org" <pablo@netfilter.org>,
        "kaber@trash.net" <kaber@trash.net>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        Mark Charlebois <charlebm@gmail.com>,
        =?utf-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>
Subject: RE: [PATCH v2] net: netfilter: LLVMLinux: vlais-netfilter
Thread-Topic: [PATCH v2] net: netfilter: LLVMLinux: vlais-netfilter
Thread-Index: AQHPQnEJEP702KUMQ0ePAIHbN3UAt5rmloBA
Date: Tue, 18 Mar 2014 09:41:50 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E0065@AcuExch.aculab.com>
References: <022D9517-4804-47BB-B789-CCF25F25C1ED@me.com>
 <1395123121-27053-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395123121-27053-1-git-send-email-behanw@converseincode.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2I9hIiu003915

From:  behanw@converseincode.com
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
> xt_repldata.h with a C99 compliant flexible array member and then calculated
> offsets to the other struct members. These other members aren't referenced by
> name in this code, however this patch maintains the same memory layout and
> padding as was previously accomplished using VLAIS.
> 
> Had the original structure been ordered differently, with the entries VLA at
> the end, then it could have been a flexible member, and this patch would have
> been a lot simpler. However since the data stored in this structure is
> ultimately exported to userspace, the order of this structure can't be changed.

Why not just remove the last element and allocate space for it after the
structure?
That would reduce the complexity of the patch and the unreadability
of the new code.
I realise that the alignment of type##_error is 'tricky' to determine.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
