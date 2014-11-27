Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaK0Qfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:35:40 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaK0Qfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:35:39 -0500
Message-ID: <547752D1.6040000@nod.at>
Date: Thu, 27 Nov 2014 17:35:29 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1416835236-25185-1-git-send-email-richard@nod.at>		 <1416835236-25185-4-git-send-email-richard@nod.at>	 <1417102739.5858.112.camel@sauron.fi.intel.com> <54774C71.50807@nod.at> <1417105793.5858.117.camel@sauron.fi.intel.com>
In-Reply-To: <1417105793.5858.117.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.11.2014 um 17:29 schrieb Artem Bityutskiy:
> On Thu, 2014-11-27 at 17:08 +0100, Richard Weinberger wrote:
>>> Obviously, there is some misunderstanding. This looks like lack of
>>> separation and misuse of layering. I am missing explanations why I am
>>> wrong...
>>
>> So you want me to use the UBI WL background thread for the scheduled fastmap work?
> 
> No. It is more like either use it or do not use it.

Sorry, I don't understand.
What do you want to do to?

>> I didn't do it that way because you said more than once that fastmap is fastmap and
>> WL is WL. Therefore I've separated it.
> 
> And "separated" meaning adding this code to wl.c?
> 
> +#ifdef CONFIG_MTD_UBI_FASTMAP
> +       flush_work(&ubi->fm_work);
> +#endif
> 
> Could it be separated some more then?
> 

Of course, commit "UBI: Move fastmap specific functions out of wl.c" does.
But this commit is *bugfix* commit.

Thanks,
//richard
