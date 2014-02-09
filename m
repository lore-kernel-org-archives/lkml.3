Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaBIXQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 18:16:39 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56974 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaBIXQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 18:16:30 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F80C4E.5040805@roeck-us.net>
Date: Sun, 09 Feb 2014 15:16:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Paul Bolle <pebolle@tiscali.nl>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-25-git-send-email-richard@nod.at> <1391974709.25855.3.camel@x220> <52F7DF51.8000507@nod.at> <52F7F486.7040003@roeck-us.net> <52F7F54B.3050602@nod.at>
In-Reply-To: <52F7F54B.3050602@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 01:38 PM, Richard Weinberger wrote:
> Am 09.02.2014 22:35, schrieb Guenter Roeck:
>> I could understand if you would replace DEPRECATED with BROKEN,
>> but causing a potentially large number of broken builds and
>> then leave it to others to clean up the resulting mess doesn't
>> make any sense to me and should, in my opinion, be rejected.
>
> Currently the mess is hidden by bad Kconfig dependencies.
> We have to face it. :)
>

You can make the breakage obvious by using BROKEN instead
of DEPRECATED. Then it can be fixed.

Otherwise you could, using your logic, remove all BROKEN
dependencies as well (all 90 or so of them). That symbol,
after all, is just as orphan as DEPRECATED.

The point here is to not unnecessarily introduce build problems.
There are people out there trying to ensure that no new build
breakages are introduced. By making X configurations
non-buildable, all you accomplish is to ensure that no one will
be able to discover real new build problems anymore, because
those new problems will all disappear in the build breakage
noise you introduced.

So, in practice, all you accomplish is to make the kernel
less maintainable. If that is your goal, mission accomplished.
Otherwise I would kindly ask you to reconsider.

Note that I would not mind some big cleanup effort to simply
remove all code marked as BROKEN, and I would be more than
happy to assist in such an effort.

However, breaking builds on purpose in the hope that someone
would magically show up and fix it is just plain wrong.

Note that I do not refer to a specific platform.

Guenter

