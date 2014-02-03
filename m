Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaBCXIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:08:19 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:48186 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaBCXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:08:17 -0500
Message-ID: <52F0215B.5040209@lwfinger.net>
Date: Mon, 03 Feb 2014 17:08:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel WARNING splat in 3.14-rc1
References: <52EFF658.2080001@lwfinger.net> <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 02:39 PM, David Rientjes wrote:
> Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly required
> that add_full() and remove_full() hold n->list_lock.  The lock is only
> taken when kmem_cache_debug(s), since that's the only time it actually
> does anything.
>
> Require that the lock only be taken under such a condition.
>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: David Rientjes <rientjes@google.com>

You may add a "Tested-by: Larry Finger <Larry.Finger@lwfinger.net>". The patch 
cleans up the splat on my system. Thanks for the quick response.

Larry

