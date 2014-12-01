Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaLALFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaLALFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:05:24 -0500
Message-ID: <547C4B59.1000807@redhat.com>
Date: Mon, 01 Dec 2014 12:04:57 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com> <20141201102529.GA9666@mwanda>
In-Reply-To: <20141201102529.GA9666@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 11:27 AM, Dan Carpenter wrote:
> On Mon, Aug 25, 2014 at 10:01:39PM +0200, Daniel Borkmann wrote:
>> zatimend has reported that in his environment (3.16/gcc4.8.3/corei7)
>> memset() calls which clear out sensitive data in extract_{buf,entropy,
>> entropy_user}() in random driver are being optimized away by gcc.
>>
>> Add a helper memzero_explicit() (similarly as explicit_bzero() variants)
>> that can be used in such cases where a variable with sensitive data is
>> being cleared out in the end. Other use cases might also be in crypto
>> code. [ I have put this into lib/string.c though, as it's always built-in
>> and doesn't need any dependencies then. ]
>>
>> Fixes kernel bugzilla: 82041
>
> What???
>
> That's not ok.  We totally rely on memset to work.  Every single memset
> that I have added was absolutely necessary.  This should be fixed
> so that memset works instead of adding a work around for specific
> drivers.

Well, BSD has helpers such as bzero_explicit() for such cases to work
around this, which memzero_explicit() similarly does; see also [1].

   [1] https://gcc.gnu.org/ml/gcc-help/2014-10/msg00059.html
