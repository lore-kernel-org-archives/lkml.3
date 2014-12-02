Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaLBAjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:39:48 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43112 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaLBAjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <1417477480.21136.0@mail.thefacebook.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<CA+55aFxOKsK-E438QEOd5Tq2dUZjO8sOnQtpTtPmpBKngmgpkg@mail.gmail.com>
	<1417477480.21136.0@mail.thefacebook.com>
Date: Mon, 1 Dec 2014 16:39:45 -0800
X-Google-Sender-Auth: KJ_qhHDKvWVwMNy7xVbfAHfH4So
Message-ID: <CA+55aFzjUd90WFnQWyMErQG-CBvdipoi1qQexBJpWh7UKKeFkg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 3:44 PM, Chris Mason <clm@fb.com> wrote:
>
> But looking harder it's probably inside wait_sb_inodes:
>
>        spin_lock(&inode_sb_list_lock);

Yeah, that's a known pain-point for sync(), although nobody has really
cared enough, since performance of parallel sync() calls is usually
not very high on anybody's list of things to care about except when it
occasionally shows up on some old Unix benchmark (maybe AIM, I
forget).

Anyway, lock debugging will make what is usually not noticeable into a
"whee, that's horrible", because the lock debugging overhead is often
many *many* times higher than the cost of the code inside the lock..

                  Linus
