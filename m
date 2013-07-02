Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3GBXOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:14:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:14:29 -0400
Date: Tue, 02 Jul 2013 16:14:28 -0700 (PDT)
Message-Id: <20130702.161428.1703028286206350504.davem@davemloft.net>
To: vyasevich@gmail.com
Cc: ydroneaud@opteya.com, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/13] sctp: use get_unused_fd_flags(0) instead of
 get_unused_fd()
From: David Miller <davem@davemloft.net>
In-Reply-To: <51D312E8.6090702@gmail.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
	<6d4271e2e0b05ae2728cba1d890e77cac50cf8f0.1372777600.git.ydroneaud@opteya.com>
	<51D312E8.6090702@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 02 Jul 2013 13:50:32 -0400

> On 07/02/2013 12:39 PM, Yann Droneaud wrote:
>> Macro get_unused_fd() is used to allocate a file descriptor with
>> default flags. Those default flags (0) can be "unsafe":
>> O_CLOEXEC must be used by default to not leak file descriptor
>> across exec().
>>
>> Instead of macro get_unused_fd(), functions anon_inode_getfd()
>> or get_unused_fd_flags() should be used with flags given by userspace.
>> If not possible, flags should be set to O_CLOEXEC to provide userspace
>> with a default safe behavor.
>>
>> In a further patch, get_unused_fd() will be removed so that
>> new code start using anon_inode_getfd() or get_unused_fd_flags()
>> with correct flags.
>>
>> This patch replaces calls to get_unused_fd() with equivalent call to
>> get_unused_fd_flags(0) to preserve current behavor for existing code.
>>
>> The hard coded flag value (0) should be reviewed on a per-subsystem
>> basis,
>> and, if possible, set to O_CLOEXEC.
>>
>> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied to net-next, thanks.
