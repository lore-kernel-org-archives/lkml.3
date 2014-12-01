Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaLAUgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:36:37 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:39538 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaLAUgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
References: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
Date: Mon, 1 Dec 2014 12:36:34 -0800
X-Google-Sender-Auth: BU29cIVBEWXcU8_qjnK_HKdVBKA
Message-ID: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 12:28 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
>
>         Hi Paul. Please, I'd like the patch, because without
> preemption, I'm unable to trigger this bug.

Ok, that's already interesting information. And yes, it would probably
be interesting to see if CONFIG_PREEMPT=y but !CONFIG_TREE_PREEMPT_RCU
then solves it too, to narrow it down to one but not the other..

DaveJ - what about your situation? The standard Fedora kernels use
CONFIG_PREEMPT_VOLUNTARY, do you have CONFIG_PREEMPT and
CONFIG_TREE_PREEMPT_RCU enabled? I think you and Sasha both saw some
RCU oddities too, no?

                    Linus
