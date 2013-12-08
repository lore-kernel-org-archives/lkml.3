Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab3LHRjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:39:39 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:32840 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3LHRji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:39:38 -0500
Message-ID: <52A4AED8.3000506@gmail.com>
Date: Sun, 08 Dec 2013 10:39:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net>
In-Reply-To: <20131206115627.GA2279@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/13, 4:56 AM, Arnaldo Carvalho de Melo wrote:
> You get correct results because the modules/kallsyms info you provided
> matches the VM you're testing, i.e. the pid test is not needed.
>
> I think we need to specify for which PID the --guestmodules and
> --guestkallsyms is provided, so that it can refuse to use it for pids
> where it is invalid.

Those are arguments are shortcut defaults for guests. If the VMs are not 
running the same kernel use guestmount and pid specific directories. e.g.,

/tmp/guestmount/<pid>/proc/kallsyms

David
