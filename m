Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3DOK6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:58:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56754 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3DOK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:58:52 -0400
MIME-Version: 1.0
Date: Mon, 15 Apr 2013 13:58:50 +0300
X-Google-Sender-Auth: W0nDPkIn6iOmg5122NmqIihkozQ
Message-ID: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
Subject: [PROBLEM] perf requires python-devel to compile
From: Pekka Enberg <penberg@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Witten <mfwitten@gmail.com>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing this when I try to build perf in v3.9-rc7:

[penberg@golgotha perf]$ make
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK -D_FORTIFY_SOURCE=2
    CHK bionic
    CHK libelf
    CHK libdw
Makefile:584: No libdw.h found or old libdw.h found or elfutils is
older than 0.138, disables dwarf support. Please install new
elfutils-devel/libdw-dev
    CHK libunwind
    CHK -DLIBELF_MMAP
    CHK libaudit
    CHK libnewt
Makefile:673: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
    CHK perl
Makefile:755: The path '/usr/bin/python-config' is not executable.
Makefile:755: *** Please set 'PYTHON_CONFIG' appropriately.  Stop.

The problem is that I didn't have python-devel package installed and
get-executable-or-default decides to error out instead of letting the
Makefile disable Python support.

                        Pekka
