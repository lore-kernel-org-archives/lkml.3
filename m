Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3LAVz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 16:55:26 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48558 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3LAVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 16:55:22 -0500
Date: Sun, 1 Dec 2013 13:50:13 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: dwmw2@infradead.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, rjw@rjwysocki.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] power_supply: Fix Oops from NULL pointer
 dereference from wakeup_source_activate
Message-ID: <20131201215012.GA6271@lizard>
References: <cover.1385138418.git.shuah.kh@samsung.com>
 <739760cf69fca695a825246b5f6f1849cd2cf57a.1385138418.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <739760cf69fca695a825246b5f6f1849cd2cf57a.1385138418.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:54:28AM -0700, Shuah Khan wrote:
> power_supply_register() calls device_init_wakeup() to register a wakeup
> source before initializing dev_name. As a result, device_wakeup_enable()
> end up registering wakeup source with a null name when wakeup_source_register()
> gets called with dev_name(dev) which is null at the time.
> 
> When kernel is booted with wakeup_source_activate enabled, it will panic
> when the trace point code tries to dereference ws->name.
> 
> Fixed the problem by moving up the kobject_set_name() call prior to accesses
> to dev_name(). Replaced kobject_set_name() with dev_set_name() which is the
> right interface to be called from drivers. Fixed the call to device_del() prior
> to device_add() in for wakeup_init_failed error handling code.

Applied, thanks a lot!

Anton
