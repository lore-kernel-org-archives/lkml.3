Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3FZQUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:20:39 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59051 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3FZQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:20:37 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 26 Jun 2013 13:20:16 -0300
Message-ID: <CAKi4VA+RBToB3fO21N-QWdPZeqGpg1ASHzn3vwB9t64ApdwrsA@mail.gmail.com>
Subject: module refcnt underflow
To: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-modules <linux-modules@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While checking somethings for a next release of kmod I noticed this
strange thing:

cat /sys/module/acpi_cpufreq/refcnt
18446744073709551614

We outputs this as "-1" in lsmod because we treat the value as signed.
I was just going to change it to unsigned to make it compatible with
what module-init-tools does but... For me it looks like a bug in the
kernel since in this file we just have the output of
kernel/module.c:module_refcount()

I have this behavior on 3.9.2 but judging by the missing commits in
kernel/module.c, this would also happen in latest head. I've never
seen such a value so I guess it might be difficult to reproduce it
again.

Any hints on what could cause decs to be greater than incs in module_refcount()?


--

Lucas De Marchi
