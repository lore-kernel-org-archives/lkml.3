Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3EUWTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:19:10 -0400
Received: from tex.lwn.net ([70.33.254.29]:41279 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab3EUWTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:19:06 -0400
Date: Tue, 21 May 2013 16:19:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ktap 0.1 released
Message-ID: <20130521161903.333d7e74@lwn.net>
In-Reply-To: <519AF05E.1050808@huawei.com>
References: <519AF05E.1050808@huawei.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 11:56:14 +0800
"zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> we welcome bug reports and fixes for the issues.

I'm messing with it...first impression:

	unable create tracepoint event sys_enter_mmap on cpu 4, err: -19
	unable create tracepoint event sys_enter_mmap on cpu 5, err: -19
	unable create tracepoint event sys_enter_mmap on cpu 6, err: -19
	unable create tracepoint event sys_enter_mmap on cpu 7, err: -19
	[...]

Unsurprising, this is a four-core system.  The code reads:

> 	for_each_possible_cpu(cpu)
>		enable_tracepoint_on_cpu(cpu, &attr, call, arg, type);

Maybe that needs to be for_each_online_cpu() instead?

jon
