Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaFJPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaFJPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:13:21 -0400
Message-ID: <5397207E.4040205@redhat.com>
Date: Tue, 10 Jun 2014 17:13:02 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
Subject: Re: [PATCH 4/7] lib/random32.c: Use <asm/unaligned.h> instead of
 hand-rolling it
References: <20140608124031.2571.qmail@ns.horizon.com>
In-Reply-To: <20140608124031.2571.qmail@ns.horizon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 02:40 PM, George Spelvin wrote:
...
>>> +	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32))
>>> +		put_unaligned_le32(prandom_u32_state(state), p+i);
>
>> Nit: 'p + i'
>
> I don't really care, but I'm happy without the spaces; I add them
> to show what binds more weakly, and in this case that's the
> argument-separating comma.

If you invent such things, then first send a patch to
Documentation/CodingStyle to change and discuss this.

Otherwise, I urge you to read:

   vi Documentation/CodingStyle +206
