Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3E0RjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3E0RjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:39:21 -0400
Message-ID: <51A39A3F.8080903@redhat.com>
Date: Mon, 27 May 2013 13:39:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: atomlin@redhat.com
CC: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        aquini@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
References: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
In-Reply-To: <1369599557-22677-1-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 04:19 PM, atomlin@redhat.com wrote:
> From: Aaron Tomlin <atomlin@redhat.com>
>
> Since v1:
>   - Removed unnecessary parentheses
>
> ---8<---
>
> Failed GFP_ATOMIC allocations by the network stack result in dropped
> packets, which will be received on a subsequent retransmit, and an
> unnecessary, noisy warning with a kernel backtrace.
>
> These warnings are harmless, but they still cause users to panic and
> file bug reports over dropped packets. It would be better to hide the
> failed allocation warnings and backtraces, and let retransmits handle
> dropped packets quietly.

Yes please. Getting memory management bug reports for
dropped network packets got old years ago.  Lets get
rid of those messages.

> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

