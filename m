Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3HFIGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:06:02 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36975 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3HFIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:05:58 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-77-5200ae64ce95
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
References: <1375700932-2851-1-git-send-email-phil.carmody@partner.samsung.com>
 <1375750807.1968.20.camel@joe-AO722>
In-reply-to: <1375750807.1968.20.camel@joe-AO722>
Subject: RE: [PATCH 1/1] checkpatch: fix some whitespace issues caused by --fix
Date: Tue, 06 Aug 2013 11:05:52 +0300
Message-id: <000901ce927b$c5b74c80$5125e580$%carmody@partner.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6SQE2738SoIDseTjWPIS6OQcatfAAOryAw
Content-language: en-gb
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7op6xiCDLasMrL4sFbDYvb9xywW
	l3fNYXNg9pjV0Mvm8WXVNWaPz5vkApijuGxSUnMyy1KL9O0SuDJ+zjjMWnCHs2LG4sssDYyX
	2bsYOTkkBEwk9s9ogLLFJC7cW8/WxcjFISSwlFFiyfPLLBDOX0aJnbvOsIBUsQmYSkxZ8Y0J
	xBYRUJZYsOgzWJxZwFji3dTDzF2MHEANZRI3ngmDhDkFDCXeLV3ACGILC/hLTFvzCWwZi4Cq
	xO1zn9lAbF4BT4mD/76zQNiCEj8m34MaqSWxfudxJghbXmLzmrdg4yUE1CUe/dWFuMBI4uCE
	tawQJeISD2f0Mk1gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghwf5lB+PiY1aHGAU4GJV4eBOu/g8UYk0sK67MPcQowcGsJMLLWMUQJMSbklhZlVqUH19U
	mpNafIiRiYNTqoEx48ZWqbcHf75qiTu7cu6k92mZc7x2sxyYLDHvpdpEhlPn5/88a1AY02+c
	NlWqw2X+//asI4caeZQvW/zfz2u7/++eiYtV2faHFBm0rz+8j+XD8wNewneWfN6WU2V/L5KZ
	a9fbLU8Dfi28uudEe3rHV93Hr9g565e2l4icd2TZ4aFr/9Nj9cOGbUosxRmJhlrMRcWJAAku
	PQRUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2013-08-05 at 14:08 +0300, Phil Carmody wrote:
> > Lines with incorrect spacing around an operator, such as:
> >   bystander, correct,incorrect
> > would get "fixed" to
> >   bystander,correct, incorrect
> > as the correct argument as well as the incorrectly-spaced operator
> > were both being trimmed. The correct argument only needs to be right
> > trimmed.
> 
> Thanks for the patch, but I think it needs a different fix.

I think it's the right approach, but you're right, it doesn't
fix all the problems. However, in part that's because many 
copies of the string, or bits of it, are created, and when 
one copy is modified, the others don't replicate that change.

> Even after your patch the --fix option still makes a mess of several
> code spacing issues.

Indeed. Just seen - func(foo,&bar); becoming func(foo,  &bar);, 
as --fix wants to put a space both after the ',' and before the '&'.

> I'll work on it and propose something soonish.

It's very much a WIP - I'll send my bride-of-checkpatch to you 
as soon as I've written some blurb. It might be that the 
complexities inside checkpatch can't be overcome, and it's
easier to address the changes entirely in a separate script?

Phil


