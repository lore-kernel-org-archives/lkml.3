Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaKBIQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 03:16:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaKBIQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 03:16:52 -0500
Message-ID: <5455E871.7080700@suse.de>
Date: Sun, 02 Nov 2014 09:16:49 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, Peter Foley <pefoley2@pefoley.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        "afaerber@suse.de" <afaerber@suse.de>
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
References: <1414454639-7491-1-git-send-email-agraf@suse.de> <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com> <20141028084735.6338d01b@lwn.net> <CF6E40FB-3CB1-43BD-8691-46AD21DA62A0@suse.de> <5454CC07.1070605@gmail.com> <54554DBC.3050607@suse.de> <CAJs94EaS5EQ=X9vRJzzApMuj9uiqH78Qq01HFNnRSXHNjeHRGw@mail.gmail.com>
In-Reply-To: <CAJs94EaS5EQ=X9vRJzzApMuj9uiqH78Qq01HFNnRSXHNjeHRGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.11.14 08:46, Matwey V. Kornilov wrote:
> I wish I knew. We need KBuild guru to ask how to take into account
> host architecture.

Hrm. At least this patch makes things more consistent with the other
Documentation makefiles:

Documentation/timers/Makefile:hostprogs-$(CONFIG_X86) := hpet_example
Documentation/vDSO/Makefile:hostprogs-$(CONFIG_X86) :=
vdso_standalone_test_x86

But I agree, it is wrong in general - hostprogs should make sure the
host arch matches.

We could maybe just evaluate the host uname output:

  ifeq ($(shell uname -m),x86_64)
    hostprogs-$(CONFIG_X86) := ...
  endif

Then we're double safe ;). Not sure how to easily add x86 to the mix as
well here, but I'm not sure anyone cares. Do people still compile on
32bit x86 hosts? And expect Documentation/ examples to build?


Alex
