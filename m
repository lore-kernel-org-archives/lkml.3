Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbaLCATq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:19:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411AbaLCATo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:19:44 -0500
Message-ID: <547E56E1.2080105@redhat.com>
Date: Wed, 03 Dec 2014 01:18:41 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 8/8] wusb: replace memset by memzero_explicit
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr> <1417366774-32412-9-git-send-email-Julia.Lawall@lip6.fr> <20141203001408.GB21569@kroah.com>
In-Reply-To: <20141203001408.GB21569@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 01:14 AM, Greg Kroah-Hartman wrote:
> On Sun, Nov 30, 2014 at 05:59:34PM +0100, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Memset on a local variable may be removed when it is called just before the
>> variable goes out of scope.  Using memzero_explicit defeats this
>> optimization.  A simplified version of the semantic patch that makes this
>> change is as follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> identifier x;
>> type T;
>> @@
>>
>> {
>> ... when any
>> T x[...];
>> ... when any
>>      when exists
>> - memset
>> + memzero_explicit
>>    (x,
>> -0,
>>    ...)
>> ... when != x
>>      when strict
>> }
>> // </smpl>
>>
>> This change was suggested by Daniel Borkmann <dborkman@redhat.com>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>> Daniel Borkmann suggested that these patches could go through Herbert Xu's
>> cryptodev tree.
>
> Why?  There's no dependancy on anything in the cryptodev tree,
> memzero_explicit is in Linus's tree now.

Sorry, I guess this was not really clear, that comment actually only
refers to the arch/*/crypto/ patches.

Anyway, thanks for queueing this up, Greg.

Cheers,
Daniel
