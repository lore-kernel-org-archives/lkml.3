Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaABCY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:24:59 -0500
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:55799 "EHLO
	homiemail-a82.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750763AbaABCY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:24:58 -0500
X-Greylist: delayed 40401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2014 21:24:58 EST
Message-ID: <52C4CDF8.5000508@shealevy.com>
Date: Wed, 01 Jan 2014 21:24:56 -0500
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131228 Thunderbird/17.0.8
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Build and Source Tree Requirements for Out-of-tree Modules
References: <52C43027.7010702@shealevy.com> <52C474CB.8000300@gmail.com>
In-Reply-To: <52C474CB.8000300@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/01/2014 03:04 PM, Austin S Hemmelgarn wrote:
> On 01/01/2014 10:11 AM, Shea Levy wrote:
>> Hi all,
>>
>> I am a package maintainer for the kernel for the NixOS
>> distribution. We support users building out-of-tree modules and
>> other packages that might depend on the kernel source or build
>> trees, but make modules_install copies the entire source and build
>> trees (we build with $(O) set) to $(INSTALL_PATH), and those are
>> some big paths to keep around. Is there any documentation on which
>> of those files should actually be needed by any out-of-tree tools?
>> For example I'm guessing the intermediate object files in the build
>> tree or the .c files in the source tree are not necessary, but it
>> would be nice if there were a definitive list of what could be
>> removed to save space.
> Running 'make modules_prepare' in a clean source tree should set up
> the sources with everything needed for out of tree modules, it largely
> amounts to the .config file, a few scripts, and a couple of specific
> other files.
>
Thanks so much! It looks like this can replace the build tree, so now 
all I need to figure out is how much of the source tree I can get rid 
of. The Makefile in the modules_prepare directory just basically 
re-calls make with -C /path/to/source/tree, so I need at least the 
Makefile...

~Shea Levy
