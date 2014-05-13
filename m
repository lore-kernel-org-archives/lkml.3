Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbaEMLLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:11:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53272 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbaEMLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:11:50 -0400
Message-ID: <1399979458.2925.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH] ima: audit log files opened with O_DIRECT flag
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 13 May 2014 07:10:58 -0400
In-Reply-To: <30700.1399965547@jrobl>
References: <1399926266.6471.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1399937259.25932.1.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <30700.1399965547@jrobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051311-6688-0000-0000-000001C6536B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 16:19 +0900, J. R. Okajima wrote: 
> Mimi Zohar:
> > As a temporary fix, do not measure, appraise, or audit files
> > opened with the O_DIRECT flag set.  Just audit log it.
> 
> I have no objection about the patch, but have a question.
> Are you intending to put it into mainline now (and stable too)? Or is
> this a local bandage for whoever have met the problem (like me)?

Yes, for the time being.

> In other words, should I wait for another lock free solution from Dmitry
> Kasatkin?

In addition to the lockdep issue, there is a separate problem of reading
the file opened w/O_DIRECT flag.  Dmitry is about to post two patches,
with a detailed explanation.  The first patch re-introduces the
iint->mutex.  The other patch reads the file opened w/O_DIRECT flag.
Neither patch is trivial.

> By the way, the mail is not delivered to stable-ML while there is
> "Cc: stable..." line in the commit log.

The CC shouldn't have been included in an RFC.

Mimi

