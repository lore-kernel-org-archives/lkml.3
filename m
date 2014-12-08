Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaLHPAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:00:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLHPAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:00:02 -0500
Message-ID: <5485BCEA.30207@oracle.com>
Date: Mon, 08 Dec 2014 09:59:54 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Smelkov <kirr@nexedi.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/liblockdep: Fix debug_check thinko in mutex destroy
References: <1418036879-31944-1-git-send-email-kirr@nexedi.com>
In-Reply-To: <1418036879-31944-1-git-send-email-kirr@nexedi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 06:07 AM, Kirill Smelkov wrote:
> In mutex destroy code currently we pass to debug_check_no_locks_freed()
> 
>     [mem_from, mem_end)
> 
> address region. But debug_check_no_locks_freed() accepts
> 
>     mem_from, mem_*len*
> 
> i.e. second parameter is region length, not end address. And it was
> always so, starting from 2006 (fbb9ce95 "lockdep: core").
> 
> Fix it, or else on a mutex destroy we wrongly check
> much-wider-than-mutex region and can find not-yet-released other locks
> there and wrongly report BUGs on them.

Great catch, thanks!


Thanks,
Sasha
