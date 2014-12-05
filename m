Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaLEGia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:38:30 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:43305 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLEGi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:38:29 -0500
MIME-Version: 1.0
In-Reply-To: <54813C03.8040009@oracle.com>
References: <20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<20141202193252.GB17595@redhat.com>
	<547E4C14.6040509@oracle.com>
	<54813C03.8040009@oracle.com>
Date: Thu, 4 Dec 2014 22:38:28 -0800
X-Google-Sender-Auth: gbuijnAQ8TXopHc5SJ9SyE49eHI
Message-ID: <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 9:00 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Just to add to this: I've enabled the simplest level of verbosity in the fault
> injection options, and RCU stalls are again easy to trigger:

Where do you log to?

In particular, do you have some serial line logging enabled (perhaps
even without anybody listening)? Or network logging?

We've definitely had cases where logging itself is so slow that it
triggers watchdogs etc. Logging to a serial line can take for*ever* in
modern terms..

                      Linus
