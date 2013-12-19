Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3LSPpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:45:25 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57140 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LSPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:45:24 -0500
MIME-Version: 1.0
In-Reply-To: <52B313D8.6090508@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	<1387465429-3568-22-git-send-email-levex@linux.com>
	<20131219152044.GB16994@htj.dyndns.org>
	<52B31158.3030801@linux.com>
	<CAOS58YO7Ot69kv=2UOTDORMAtgL2EOq-voEj3JLCDb8Rv=LABA@mail.gmail.com>
	<52B313D8.6090508@linux.com>
Date: Thu, 19 Dec 2013 10:45:21 -0500
X-Google-Sender-Auth: TLBq4Cxnwr-JWlQ5LeTGY2yFTJI
Message-ID: <CAOS58YPnh40gdZFJ_8H2-ZnHxibQNW387ivtubH4p8G-h5QCtw@mail.gmail.com>
Subject: Re: [PATCH 21/38] workqueue: add missing put_device call
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:42 AM, Levente Kurusa <levex@linux.com> wrote:
>> Greg, the API as described by the comment is really weird and
>> unconventional. Failed calls are not supposed to have side effects
>> which require explicit cleanup. Can we please update the comment?
>>
>
> Yes, it was already discussed that it would be more sane to have
> device_register() call put_device() if it would fail, but Greg
> said that the API was designed so that no kfree()s happen in the core.

Of course not. For the third time: A failed call shouldn't make
material changes which makes difference to its caller. An obj which
failed init should be destructible in the exact reverse operation that
the caller took to create it. This is a fundamental rule of any API
design. There sure are occasional exceptions but there's no reason to
deviate from that here.

Thanks.

-- 
tejun
