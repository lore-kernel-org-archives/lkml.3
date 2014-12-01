Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaLANkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:40:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaLANkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:40:08 -0500
Message-ID: <547C6F88.9000206@redhat.com>
Date: Mon, 01 Dec 2014 14:39:20 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com> <20141201102529.GA9666@mwanda> <547C4B59.1000807@redhat.com> <20141201112957.GC5048@mwanda> <20141201113815.GD5048@mwanda>
In-Reply-To: <20141201113815.GD5048@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 12:38 PM, Dan Carpenter wrote:
> On Mon, Dec 01, 2014 at 02:29:57PM +0300, Dan Carpenter wrote:
>> On Mon, Dec 01, 2014 at 12:04:57PM +0100, Daniel Borkmann wrote:
>>> Well, BSD has helpers such as bzero_explicit() for such cases to work
>>> around this, which memzero_explicit() similarly does; see also [1].
>>>
>>>    [1] https://gcc.gnu.org/ml/gcc-help/2014-10/msg00059.html
>>
>> We should make memset() a define and call a custom function internally.
>
> Or we could specify -fno-builtin-memset like the GCC people suggest.

If there's a better, reliable way, I'm all for it. To me, memzero_explicit()
seemed like the least intrusive variant doing the job, I'm unsure if globally
setting -fno-builtin-memset will come with unforeseen side-effects on some
archs (besides performance-wise).
