Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaKMQ22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:28:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38560 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaKMQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:28:26 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-9b-5464dc2887da
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: balbi@ti.com
Cc: "'Robert Baldyga'" <r.baldyga@samsung.com>,
        "'David Cohen'" <david.a.cohen@linux.intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        m.szyprowski@samsung.com
References: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
 <20141103161102.GM27425@saruman> <20141105194321.GS6548@saruman>
 <20141113024414.GA19072@saruman>
In-reply-to: <20141113024414.GA19072@saruman>
Subject: RE: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Date: Thu, 13 Nov 2014 17:28:22 +0100
Message-id: <0b1401cfff5e$d86dd8c0$89498a40$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/+66/2STk8G9MDQTKcu9nMJ4GNnAAZPumg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7oad1JCDE7N5bKY9bKdxeLg/XqL
	n5fvs1s0L17PZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg95p0M9Ng/dw27x7o/r5g8
	+rasYvQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGceePGEt6OGr6Jx9ir2BcQV3FyMnh4SA
	iUT3maMsELaYxIV769m6GLk4hASWMko8urQXymlgkljwfRZTFyMHB5uAvsS8XaIgDSICAhLr
	X1xiB6lhFvjFKPHu4zMWiIbVjBKfd/5iBqniFNCVaFl/kwnEFhZwlli6YyOYzSKgKrF2UT87
	iM0r4Chx8+4dKFtQ4sfke2AnMQtoSazfeZwJwpaX2LzmLTPIERIC6hKP/upCHGEksX/2MUaI
	EhGJuw3PWScwCs1CMmkWkkmzkEyahaRlASPLKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ
	SPqyg3HxMatDjAIcjEo8vB+4U0KEWBPLiitzDzFKcDArifB6HwYK8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYFQ59mPp2S+3Yg5oWH3rbFvHlxX3+7xWHfu7aKui2KIzXPXalq1SuSn+F/72chn+
	cLIPm1f+4sBqi9lvnn18OmH75N89n01NfyRrZaXM12XX1ll+ZMtCqZm9eiKv2j4H9df1C7b9
	T+1/L5JSW2g6JSvoWegi2X2LOXOuFX0+Mk9BN9m3ynR6sBJLcUaioRZzUXEiABrS79iCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, November 13, 2014 3:44 AM
> To: Felipe Balbi
> Cc: Robert Baldyga; David Cohen; gregkh@linuxfoundation.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> mina86@mina86.com; andrzej.p@samsung.com; m.szyprowski@samsung.com;
> k.opasiak@samsung.com
> Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode

(...)

> > > David, you have been messing with ffs lately, can I get a
> Tested-by
> > > from you on this patch ?
> >
> > ping. David ? Any chance you can test this one out ?
> 
> a reminder on this request, it's getting close to tree lockdown
> (probably another 2 to 3 weeks).

I have tested this patch today but I'm afraid that I can't give
tested-by tag:

When I kill the daemon and then reconnect my device I get on my host:

[776092.877175] usb 1-1.1: can't set config #1, error -32

While on device there is only:

[ 2147.035340] configfs-gadget gadget: high-speed config #1: The only
one

Moreover, I'm not very enthusiastic about the convention in which we
allow
to reconnect the device without any changes.

In my opinion when daemon has been killed we should allow user to finish
communication with other functions and then simply unbind our gadget.
This should happen not only on reconnection but also when host is trying
to enable configuration which contains this function "zombie".
This function is not fully operational so it is very good idea to
allow user to finish his job with other functions but when he reconnects
the
device we should unbind gadget to notify userspace that something is
wrong.
The same when we switch configuration.

What do you think about this Michal and Felipe?

--
Krzysiek

