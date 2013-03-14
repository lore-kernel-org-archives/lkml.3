Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab3CNQdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:33:12 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34441 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3CNQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:33:10 -0400
Message-ID: <5141F952.8000204@ahsoftware.de>
Date: Thu, 14 Mar 2013 17:22:42 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] X.509: Remove certificate date checks
References: <20130314123413.13286.62117.stgit@warthog.procyon.org.uk> <1363265300.4853.37.camel@i7.infradead.org>
In-Reply-To: <1363265300.4853.37.camel@i7.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2013 13:48, schrieb David Woodhouse:
> On Thu, 2013-03-14 at 12:34 +0000, David Howells wrote:
>> Remove the certificate date checks that are performed when a certificate is
>> parsed.  There are two checks: a valid from and a valid to.  The first check is
>> causing a lot of problems with system clocks that don't keep good time and the
>> second places an implicit expiry date upon the kernel when used for module
>> signing, so do we really need them?
>
> While the date check is entirely bogus for the specific case of module
> signing, I don't think we necessarily ought to rip it out of our generic
> X.509 support entirely.
>
> Some use cases *might* want to check the dates, and should be permitted
> to do so. Just don't refuse to even *parse* the key outside its valid
> date range... :)

Agreed (thats what my patch did).

I've introduced a new config option because I don't know if something (a 
use case I don't know) relies on the validity check of the dates in the 
parser. If there currently isn't such a user, just removing the validity 
check in the parser might be enough. Offering the parsed dates for later 
usage is still a good idea.

Regards,

Alexander

