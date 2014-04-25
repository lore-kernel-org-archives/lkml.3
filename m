Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaDYLJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:09:50 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38184 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaDYLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:09:47 -0400
MIME-Version: 1.0
Date: Fri, 25 Apr 2014 14:09:45 +0300
X-Google-Sender-Auth: qrB00oDhPt0Ad3P4FVD4E1za0HA
Message-ID: <CAOJsxLG-S2qske+o+hXKHMRLJu6McNFRi=tDQ8iraq=w_4oonA@mail.gmail.com>
Subject: [PROBLEM] perf report --gtk doesn't work
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing the following with v3.15-rc2:

$ ~/bin/perf report --gtk
GTK browser requested but could not find libperf-gtk.so

The library file is in $HOME/lib64 and perf attempts to look it up.
However, printing out dlerror() output shows the following:

[penberg@localhost hornet]$ ~/bin/perf report --gtk
/home/penberg/lib64/libperf-gtk.so: undefined symbol: sort_sym
GTK browser requested but could not find libperf-gtk.so

I'm not sure how this is supposed to work. sort_sym() is defined in
the 'perf' executable so how is libperf-gtk.so going to see it?

- Pekka
