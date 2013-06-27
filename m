Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3F0XZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:25:46 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36398 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3F0XZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130627152800.494a6043607a62feb35e9739@linux-foundation.org>
References: <20130619210918.DF616222D8@clements>
	<20130626162107.9237360f7646ec25f23cf5aa@linux-foundation.org>
	<CAECXXi54NUvQLY1O0oWKqgDpdXWUCCcs_4jJkRJE29DctMYVUA@mail.gmail.com>
	<20130627152800.494a6043607a62feb35e9739@linux-foundation.org>
Date: Thu, 27 Jun 2013 19:25:44 -0400
Message-ID: <CAECXXi4DpXx2A_5pHXi5aM8avRM8EScCXjB1sdrXu6nizyAzaA@mail.gmail.com>
Subject: Re: [PATCH] nbd: correct disconnect behavior
From: Paul Clements <paul.clements@us.sios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 6:28 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 27 Jun 2013 18:20:37 -0400 Paul Clements <paul.clements@us.sios.com> wrote:
> OK, but.  "Would it be safer to clear ->disconnect in NBD_DO_IT?"

About the same in terms of safety. Both ioctls have to be called to
set up the device and neither can be called again, until the device is
reset.

> If not safer, would it be cleaner?

I don't know, seems like a toss up. NBD_SET_SOCK is the earliest place
that the socket might conceivably be usable, so I wanted to clear
disconnect there (e.g., in case an alternate/new version of NBD_DO_IT,
as has been discussed, is ever implemented).

>> > The cool kids are using bool lately ;)
>> >
>>
>> Hey, maybe I want to be able to compile with gcc 2.7.2 ? :)
>
> Sob, I miss 2.7.2.  It was a good 50% faster than the new improved
> models.  But I don't think this yearning makes us cool.

No, I think it just makes us old :)
