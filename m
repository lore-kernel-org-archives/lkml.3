Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaHWRkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:40:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHWRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:40:19 -0400
Message-ID: <53F8D1FE.5050205@infradead.org>
Date: Sat, 23 Aug 2014 10:40:14 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?windows-1252?Q?Fejes_J=F3zsef?= <jozsef.fejes@gmail.com>,
        linux-kernel@vger.kernel.org, linux-stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>
Subject: Re: Problem with commit: x86, iosf: Make IOSF driver modular and
 usable by more drivers
References: <CALU-w9-ZjjnrYW5HxRCe-HGZWSK0JMwNU_zcSbKXM4JgGyLdbw@mail.gmail.com>
In-Reply-To: <CALU-w9-ZjjnrYW5HxRCe-HGZWSK0JMwNU_zcSbKXM4JgGyLdbw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/14 02:31, Fejes József wrote:
> Hi,
> 
> I think there's a problem with commit
> 6b8f0c8780c71d78624f736d7849645b64cc88b7: config IOSF_MBI is
> automatically a module and I cannot change that.
> 
> I've been using 3.15.* stable kernels. I have module support enabled,
> but I build everything into the kernel, so I don't actually have any
> modules built. I just upgraded to 3.16.1, and found out that I now
> have this one module. I cannot find it in the menu, so I edited the
> .config file by hand, but it changes back from =y to =m. Could you
> please look into fixing it, and push it to 3.16.* stable branch?

[adding David E. Box to email]

This is a mainline issue, not just a -stable issue.
Once fixed in mainline (if ever), then that fix can be added to -stable.

Fejes, you could just disable module support and then iosf_mbi would be built
into the kernel.  But as a loadable module, it won't waste memory if it's
not needed.

David, any other suggestions?
Why can't the users of IOSF_MBI just select it?  That's what many other
drivers do when they need to be sure that some functionality is present.

I'm surprised that someone else (e.g. Linus) has not complained about the
'default m' for this driver.


-- 
~Randy
