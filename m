Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaHDOx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:53:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaHDOxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:53:24 -0400
Message-ID: <53DF9E62.2090007@suse.cz>
Date: Mon, 04 Aug 2014 16:53:22 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Devin J. Pohly" <djpohly@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kbuild: use $(srctree) to locate config headers from
 external modules
References: <1406922443-22770-1-git-send-email-djpohly+linux@gmail.com> <53DF944C.2090207@suse.cz> <20140804144320.GA4379@chiri>
In-Reply-To: <20140804144320.GA4379@chiri>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-04 16:43, Devin J. Pohly wrote:
> On Mon, Aug 04, 2014 at 04:10:20PM +0200, Michal Marek wrote:
>> include/generated is located in $(KBUILD_OUTPUT), which is different
>> from $(srctree) when using O=. Can you post a sequence of commands that
>> leads to the error you are seeing?
>>
>> Thanks,
>> Michal
> 
> Well, I was attempting to do something like this:
> 
> $ make -C $KDIR M=$PWD modules
> $ make -C $KDIR M=$PWD O=$pkgdir modules_install
> 
> ... but I your statement just made the problem really obvious: I don't
> need to be using O= at all in this case.  Duh.

Right, the directory you use in make -C ... M=$PWD when building an out
of tree module is the directory you used in make O=... when building the
kernel.

Michal
