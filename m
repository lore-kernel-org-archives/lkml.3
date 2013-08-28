Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3H1Oxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:53:43 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42682 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab3H1Oxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:53:42 -0400
Message-ID: <521E0EF4.7090102@akamai.com>
Date: Wed, 28 Aug 2013 10:53:40 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dynamic debug: line queries failing due to uninitialized
 local variable
References: <20130827165003.79F28FE066@prod-mail-relay02.akamai.com> <20130827174136.GG21564@kroah.com>
In-Reply-To: <20130827174136.GG21564@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 01:41 PM, Greg KH wrote:
> On Tue, Aug 27, 2013 at 04:50:03PM +0000, jbaron@akamai.com wrote:
>> Settings of the form, 'line x module y +p', can fail arbitrarily due to an
>> uninitialized local variable. With this patch results are consistent, as
>> expected.
>>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  lib/dynamic_debug.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> How far back should this patch go for older kernels?  Is this a bug that
> people are hitting today and causing problems, or is it only a 3.11-rc
> issue?
>
> thanks,
>
> greg k-h

Looks like this was introduced in >= 3.3. So its been there for quite a
while. Its a bit of a corner case, since it requires, 'line' to be
specified before anything else. It depends on on how you order your query.

I found the bug via code inspection - no bug reports that I'm aware of.
So I wouldn't think this is an urgent fix.

Thanks,

-Jason

