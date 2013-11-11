Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3KKSvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:51:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:39259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab3KKSvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:51:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="425731742"
Message-ID: <52812829.4080508@linux.intel.com>
Date: Mon, 11 Nov 2013 10:55:37 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, rostedt@goodmis.org
Subject: Re: make oldnoconfig fix?
References: <52811DDD.3030609@linux.intel.com> <20131111181304.GB3510@free.fr>
In-Reply-To: <20131111181304.GB3510@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 10:13 AM, Yann E. MORIN wrote:
> David, All,

Hi Yann,

>
> On 2013-11-11 10:11 -0800, David Cohen spake thusly:
>> Is there a plan to fix 'make oldnoconfig' option?
>> I currently have need to it :)
>> I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
>> option is reported as a known bug, right?
>
> Sorry, I don't understand what your problem is.

Maybe I assumed it was more 'known' then it actually is :)

>
> Care to explain in details what problem you have:
>    - what you start with
>    - what you do
>    - what you get
>    - what you expected

The bug with 'oldnoconfig' is: 'make oldnoconfig' is just an alias to
'olddefconfig'. Any non-existent config is defined with its default
value instead of 'N'.

I work with embedded platforms. I need to maintain a set of defconfigs
for different products (customers some times want tailored configs, so
creating a generic one isn't an option always).

In order to have full control of the .config generated out of
defconfigs, I don't allow any CONFIG_ to be selected implicitly. So
everytime a Kconfig is changed in our internal tree, we need to update
all defconfigs either with CONFIG_... = [y|n] or # CONFIG_... is not set

If I managed to get 'make oldnoconfig' working, I could not care about
# CONFIG_... is not set and internal and changes to defconfigs would be
easily to understand and review.

>
> So we can try to reproduce the issue and investigate what is wrong.

All we need to know is explained in this commit:

commit fb16d8912db5268f29706010ecafff74b971c58d
Author: Adam Lee <adam8157@gmail.com>
Date:   Sat Sep 1 01:05:17 2012 +0800

     kconfig: replace 'oldnoconfig' with 'olddefconfig', and keep the 
old name as an alias

     As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, 'oldnoconfig' doesn't
     set new symbols to 'n', but instead sets it to their default values.

     So, this patch replaces 'oldnoconfig' with 'olddefconfig', stop making
     people confused, and keep the old name 'oldnoconfig' as an alias,
     because people already are dependent on its behavior with the
     counter-intuitive name.

     Signed-off-by: Adam Lee <adam8157@gmail.com>
     Signed-off-by: Michal Marek <mmarek@suse.cz>


>
> Since you mention an existing thread, please add a pointer (URL) to
> this thread in the archives (Use: http://marc.info/?l=linux-kbuild ).

This is the thread I was talking about: 
http://comments.gmane.org/gmane.linux.kbuild.devel/8560

Master Yoda promised to fix it when the problem gets bigger :)

Br, David
