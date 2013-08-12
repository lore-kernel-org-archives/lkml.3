Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3HLR0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:26:09 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:27519 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3HLR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:26:06 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-f8-52091aacc316
Date: Mon, 12 Aug 2013 14:25:57 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130812142557.2a43f155@samsung.com>
In-reply-to: <20130812150424.GH18018@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic>
 <20130812114932.52bb0314@samsung.com> <20130812150424.GH18018@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/hYN01UpxBBu8PMFksacqw+LzhH5vF
	h75rTBbL9/UzWlzeNYfN4uy842wW91ueslv0L+xlstjX8YDJ4s2FeywOXB7fW/tYPFr23WL3
	WLCp1GPXtp1MHov3vGTyeHBoM4vHo8UtjB6fN8kFcERx2aSk5mSWpRbp2yVwZexZMZWtoImz
	YuuKH6wNjG3sXYycHBICJhKnrixghbDFJC7cW8/WxcjFISSwhFHi6YEGKKeHSeL25H9sIFUs
	AqoS15c1MYPYbAJGEq8aW8C6RQSUJL4umssE0sAs8IFRYlbfZLCEsECYxJ49zUwgNq+AocT2
	SxCrOQV0Ja5tvcgKseE9k8TVTb1ARRxAdzhJbJ3qC1EvKPFj8j0WEJtZQEti87YmVghbXmLz
	mrfMExgFZiEpm4WkbBaSsgWMzKsYRUuLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiKkeAfjiw1W
	hxgFOBiVeHgzPnIECbEmlhVX5h5ilOBgVhLh3cLKGSTEm5JYWZValB9fVJqTWnyIkYmDU6qB
	MXbZrx9vPh/5pBy0UD190w45b265X/Mt4gJWF1dpS7wtFpXnbrJdOjVYLfaeSMBRnpDoS6eL
	Pq/4v8qP0XWOtC3Hy/xt7C6l9vwsZR6GrFauvxYtObt/xdc7WS3vFu07I/KSieXRuleiTct3
	Bq3VVupMu5r24o9FeUPuJRZV/bW7FtsyXPb4p8RSnJFoqMVcVJwIAIi75EhuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 12 Aug 2013 17:04:24 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Aug 12, 2013 at 11:49:32AM -0300, Mauro Carvalho Chehab wrote:
> > Clear win from what PoV? Userspace will need to decode a different type
> > of tracing, and implement a different logic for APEI.
> 
> There's no different type of tracing - it is the same info as in both
> cases it comes from APEI.

Well, patch 2/3 is defining a different type of tracing for memory errors,
instead of re-using the existing one.

> And if it can be done in the APEI layer, then
> we don't need the next layer.

Userspace still needs the EDAC sysfs, in order to identify how the memory
is organized, and do the proper memory labels association.

What edac_ghes does is to fill those sysfs nodes, and to call the
existing tracing to report errors.

> > Also, if both ghes_edac and this new tracing is enabled, userspace
> > will receive twice the same event, as two traces will be received for
> > the same thing.
> 
> We are, of course, going to have only one tracepoint which reports
> memory errors, not two.

Yes, that's my point.

Regards,
Mauro
