Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3JYNpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:45:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3JYNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:45:16 -0400
Message-ID: <526A75E7.30109@suse.cz>
Date: Fri, 25 Oct 2013 15:45:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Joe Perches <joe@perches.com>, yann.morin.1998@free.fr,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com> <1382599849.22433.51.camel@joe-AO722> <526A746C.3060806@free-electrons.com>
In-Reply-To: <526A746C.3060806@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.10.2013 15:38, Michael Opdenacker wrote:
> Hi Joe,
> 
> Thank you very much for your review!
> 
> On 10/24/2013 09:30 AM, Joe Perches wrote:
>> On Thu, 2013-10-24 at 07:23 +0200, Michael Opdenacker wrote:
>>
>>> +def count_param(param):
>>> +
>>> +    global source_file, bad_params_in_file
>>> +
>>> +    if os.path.isdir('.git'):
>>> +       # Use git grep when available
>>> +       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)
>>> +    else:
>>> +       # Fallback to regular grep
>>> +       count = subprocess.check_output('grep -R ' + param + ' . | grep -v defconfig | wc -l', shell=True)
>> Doesn't the grep need -w?
> Using "-w" is a good idea, and this way I can eliminate false negatives
> (for example finding matches for "PRINTK_TIME" when I'm looking for
> plain "PRINTK"). The only this is that I then need to look for both
> "PARAM" (in Kconfig files, in case the parameter is just used for
> dependency management), and for "CONFIG_PARAM" (in source files).

You can process Kconfig files and source files separately. And you can
speed up the script a lot, if you simply record all CONFIG_* strings
found in the sources, and then compare this to the set of config options
defined in Kconfig. Then you can also easily implement the opposite
check, which is currently done by scripts/checkkconfigsymbols.sh.

Michal
