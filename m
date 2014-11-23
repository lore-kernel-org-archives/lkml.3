Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaKWPpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:45:38 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48632 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaKWPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <1416756022.6651.45.camel@perches.com>
References: <5307CAA2.8060406@users.sourceforge.net> <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>
 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
 <546F2E50.5040804@users.sourceforge.net> <1416593688.6651.39.camel@perches.com>
 <5471EBAC.40903@users.sourceforge.net> <1416756022.6651.45.camel@perches.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sun, 23 Nov 2014 16:45:15 +0100
Message-ID: <CAMxnaaVb0253q7V-M7089Et+bfnmgN1E+Ttne4MFG8_U+CTbOA@mail.gmail.com>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
To: Joe Perches <joe@perches.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 4:20 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-11-23 at 15:14 +0100, SF Markus Elfring wrote:
>> >> 2. Are any additional prefixes appropriate so that further name space
>> >>    conflicts can be better avoided?
>> >
>> > To avoid possible external naming conflicts, add tb_ prefix to
>> > various ring_<foo> structs and functions.
>>
>> Do you imagine that any XEN software developers need also to reconsider
>> this implementation detail?
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/char/tpm/xen-tpmfront.c?id=fc14f9c1272f62c3e8d01300f52467c0d9af50f9#n268
>
> I think static functions can be named whatever
> the developer chooses.
Do symbols which are not exported (no EXPORT_SYMBOL_(GPL)) cause
conflicts? I was under the impression that those are module private.
If they are indeed private then I would prefer to not rename them.
