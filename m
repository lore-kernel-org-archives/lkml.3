Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaLALtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:49:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaLALtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:49:02 -0500
Message-ID: <547C558A.2040401@redhat.com>
Date: Mon, 01 Dec 2014 12:48:26 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com> <20141201102529.GA9666@mwanda> <547C4B59.1000807@redhat.com> <20141201112957.GC5048@mwanda>
In-Reply-To: <20141201112957.GC5048@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 12:29 PM, Dan Carpenter wrote:
> On Mon, Dec 01, 2014 at 12:04:57PM +0100, Daniel Borkmann wrote:
>> Well, BSD has helpers such as bzero_explicit() for such cases to work
>> around this, which memzero_explicit() similarly does; see also [1].
>>
>>    [1] https://gcc.gnu.org/ml/gcc-help/2014-10/msg00059.html
>
> We should make memset() a define and call a custom function internally.
>
> Otherwise there are thousands of calls to memset() which we would need
> to audit.  We could do some of this automatically but it's going to be a
> mess.

Sort of, yeah; for now random driver and crypto subsystem, which I consider
the main candidates, have been converted and with Julia's latest patch set
from today (via coccinelle) also remaining arch-specific crypto drivers.
