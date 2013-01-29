Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3A2Dpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:45:45 -0500
Received: from smtp.multi.fi ([85.134.37.151]:33856 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab3A2Dpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:45:43 -0500
Message-ID: <510745D9.9000209@mageia.org>
Date: Tue, 29 Jan 2013 05:45:29 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: irina.tirdea@intel.com, acme@redhat.com
Subject: the patch "perf tools: Update Makefile for Android" broke 3.8-rc
 perf build.
References: <20121212031346.B5BB366071F@gitolite.kernel.org>
In-Reply-To: <20121212031346.B5BB366071F@gitolite.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List skrev 12.12.2012 05:13:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
> Commit:     d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
> Parent:     78da39faf7c903bb6e3c20a726fde1bf98d10af8
> Author:     Irina Tirdea <irina.tirdea@intel.com>
> AuthorDate: Mon Oct 8 09:43:27 2012 +0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon Oct 8 17:42:16 2012 -0300
>
>      perf tools: Update Makefile for Android
>
>      For cross-compiling on Android, some specific changes are needed in
>      the Makefile.
>

The above patch broke perf build on i586 and x86_64:

[tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1 HAVE_CPLUS_DEMANGLE=1 
prefix=%{_prefix} all
     CHK -fstack-protector-all
     CHK -Wstack-protector
     CHK -Wvolatile-register-var
     CHK bionic
<stdin>:1:31: fatal error: android/api-level.h: No such file or directory
compilation terminated.


This is a regression since 3.7
--
Thomas

