Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaKBK3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 05:29:03 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36038 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaKBK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 05:28:59 -0500
MIME-Version: 1.0
In-Reply-To: <5455E871.7080700@suse.de>
References: <1414454639-7491-1-git-send-email-agraf@suse.de>
 <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com>
 <20141028084735.6338d01b@lwn.net> <CF6E40FB-3CB1-43BD-8691-46AD21DA62A0@suse.de>
 <5454CC07.1070605@gmail.com> <54554DBC.3050607@suse.de> <CAJs94EaS5EQ=X9vRJzzApMuj9uiqH78Qq01HFNnRSXHNjeHRGw@mail.gmail.com>
 <5455E871.7080700@suse.de>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Sun, 2 Nov 2014 14:28:36 +0400
Message-ID: <CAJs94EYdLNy5MjgvXPLYQGhzFtA5NdsuQJcmKcSunpGJhc8H0Q@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
To: Alexander Graf <agraf@suse.de>, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Foley <pefoley2@pefoley.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        "afaerber@suse.de" <afaerber@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added Yann and Michal to the discussion.

The issue is that we have

hostprogs-y := disable-tsc-ctxt-sw-stress-test
disable-tsc-on-off-stress-test disable-tsc-test

in Documentation/prctl/Makefile

and disable-tsc-ctxt-sw-stress-test has x86 assembler inside and must
be restricted only to this host architecture.


2014-11-02 11:16 GMT+03:00 Alexander Graf <agraf@suse.de>:
>
>
> On 02.11.14 08:46, Matwey V. Kornilov wrote:
>> I wish I knew. We need KBuild guru to ask how to take into account
>> host architecture.
>
> Hrm. At least this patch makes things more consistent with the other
> Documentation makefiles:
>
> Documentation/timers/Makefile:hostprogs-$(CONFIG_X86) := hpet_example
> Documentation/vDSO/Makefile:hostprogs-$(CONFIG_X86) :=
> vdso_standalone_test_x86
>
> But I agree, it is wrong in general - hostprogs should make sure the
> host arch matches.
>
> We could maybe just evaluate the host uname output:
>
>   ifeq ($(shell uname -m),x86_64)
>     hostprogs-$(CONFIG_X86) := ...
>   endif
>
> Then we're double safe ;). Not sure how to easily add x86 to the mix as
> well here, but I'm not sure anyone cares. Do people still compile on
> 32bit x86 hosts? And expect Documentation/ examples to build?
>
>
> Alex



-- 
With best regards,
Matwey V. Kornilov
http://blog.matwey.name
xmpp://0x2207@jabber.ru
