Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaHZMEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:04:53 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58490 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbaHZMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:04:51 -0400
Subject: [RFC PATCH 0/2] kmod: Support lockup option to make module
 un-removable
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Date: Tue, 26 Aug 2014 12:04:42 +0000
Message-ID: <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal>
In-Reply-To: <53FC52DA.9000303@hitachi.com>
References: <53FC52DA.9000303@hitachi.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a pair of patches which adds --lockup option to
modprobe and libkmod.

As I sent a series of patches which removes stop_machine()
from module removal: https://lkml.org/lkml/2014/8/25/142
it also adds lockup option which lock up the module in
the kernel and makes it un-removable.

These patches enables us to use that option when loading
modules. Module lockup may be good for BIG SMP machines
since the kernel skips module refcounting if the module
is locked up :)

Anyway, this is not needed if the lockup option is dropped
from the series. I send this for testing.

Thank you,

---

Masami Hiramatsu (2):
      libkmod: support lockup module option
      modprobe: Add --lockup option to make module unremovable


 libkmod/libkmod-module.c |    3 +++
 libkmod/libkmod.h        |    4 +++-
 libkmod/missing.h        |    4 ++++
 tools/modprobe.c         |   10 +++++++++-
 4 files changed, 19 insertions(+), 2 deletions(-)

--

