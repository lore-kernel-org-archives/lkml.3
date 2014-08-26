Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbaHZOYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:24:19 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47085 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbaHZOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:24:17 -0400
Message-ID: <53FC988E.8070007@plexistor.com>
Date: Tue, 26 Aug 2014 17:24:14 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Stable Tree <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Makefile: One last adjustment to relative paths
References: <53FAF8BF.3010008@plexistor.com> <53FB3CE7.9060609@suse.cz>
In-Reply-To: <53FB3CE7.9060609@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 04:40 PM, Michal Marek wrote:
> 
> So I don't understand why are you getting a message with a relative
> path. I get an absolute path as expected here:
> $ mkdir aaa
> $ make O=aaa defconfig
> make[1]: Entering directory `/home/mmarek/linux-2.6/aaa'

OK that was an operator error. You are absolutely right

What happened is that my makefile was using
	make KBUILD_OUTPUT=.build_um -C linux
and not
	make O=.build_um -C linux

This was done at the time because when building out-of-tree
modules (I Have some test modules that I build in my project)
You must use KBUILD_OUTPUT= because O= is used by the external
module build system.

But reverting to use the O= as it should be all is well
and it works as you say

Sorry for the noise
Boaz

