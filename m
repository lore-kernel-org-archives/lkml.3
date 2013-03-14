Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab3CNRmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:42:45 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45438 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab3CNRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:42:43 -0400
Message-ID: <51420C05.30206@ahsoftware.de>
Date: Thu, 14 Mar 2013 18:42:29 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] X.509: Remove certificate date checks
References: <20130314123413.13286.62117.stgit@warthog.procyon.org.uk>  <1363265300.4853.37.camel@i7.infradead.org>  <5141F952.8000204@ahsoftware.de> <1363280964.4853.89.camel@i7.infradead.org>
In-Reply-To: <1363280964.4853.89.camel@i7.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2013 18:09, schrieb David Woodhouse:
> On Thu, 2013-03-14 at 17:22 +0100, Alexander Holler wrote:
>>
>> Agreed (thats what my patch did).
>>
>> I've introduced a new config option because I don't know if something (a
>> use case I don't know) relies on the validity check of the dates in the
>> parser. If there currently isn't such a user, just removing the validity
>> check in the parser might be enough.
>
> Is there *is* such a user, it's broken already. The key could have been
> loaded (and passed the existing check) *months* ago, expired seconds
> after it was loaded, and your hypothetical user could still be happily
> trusting it.

As the user (program or whatever) calls the parser, he knows if he can 
trust it to validate dates. So there might be something for which the 
current implementation works (parsing date = using date).

I just don't know, because I've only discovered that glitch while trying 
to use modsign to be sure no unsigned module (I've compiled myself) will 
be become loaded (I compile the kernel and delete the keys right 
afterwards). So I don't know anything if and how the crypto-api to load 
x.509 keys is used besides modsign. ;)

Regards,

Alexander

