Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaHJLvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 07:51:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34019 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHJLvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 07:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140809074539.GA1467@amd.pavel.ucw.cz>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
	<20140723151459.GA6673@thunk.org>
	<20140809074539.GA1467@amd.pavel.ucw.cz>
Date: Sun, 10 Aug 2014 14:51:08 +0300
Message-ID: <CANZNk83jWeqkESFVVNb4KS+H6gQYgcVtcU8xEMiMHz7jfE52nQ@mail.gmail.com>
Subject: Re: Reading large amounts from /dev/urandom broken
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-09 10:45 GMT+03:00 Pavel Machek <pavel@ucw.cz>:
> Warn about my quick benchmark?
>
> http://atrey.karlin.mff.cuni.cz/~pavel/quickbench.html
>
> I don't see what is insane about it. Yes, there might be more
> effective generators of random bits, but that is not the point, this
> is quick&dirty attempt at benchmark.
>
> Also people will use cat /dev/urandom > /dev/sdX (and similar) to
> clean hard drives. There should be no need to warn about
> that. (Performance is going to be disk-limited anyway).

I believe "cat /dev/urandom" doesn't result in reading with _block
size_ more than 32 MB. As it was already explained by Theodore,
currently single read() operation will return "short read" when
requested to give more than 32 MB at once. You still can read more in
consecuential reading acts.

-- 
Andrey Utkin
