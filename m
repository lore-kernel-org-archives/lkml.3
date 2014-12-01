Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaLAAVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:21:21 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:42154 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaLAAVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <547b8a45.6e608c0a.20f9.1002@mx.google.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
Date: Sun, 30 Nov 2014 16:21:19 -0800
X-Google-Sender-Auth: xtMba_skNd7RCf-UI7fqY9WMmj0
Message-ID: <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 1:21 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
>
>         Yes, but "menuconfig" doesn't allow me to disable it (it's
> always checked). Newbie question: does TREE_PREEMPT_RCU depends on any
> other option? Thanks.

Maybe you'll have to turn off RCU_CPU_STALL_VERBOSE first.

Although I think you should be able to just edit the .config file,
delete the like that says

    CONFIG_TREE_PREEMPT_RCU=y

and then just do a "make oldconfig", and then verify that
TREE_PREEMPT_RCU hasn't been re-enabled by some dependency. But it
shouldn't have, and that "make oldconfig" should get rid of anything
that depends on TREE_PREEMPT_RCU.

                  Linus
