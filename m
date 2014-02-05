Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaBEPQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:16:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbaBEPQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:16:32 -0500
Message-ID: <52F255C9.3030600@suse.cz>
Date: Wed, 05 Feb 2014 16:16:25 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile, CONFIG_MODVERSIONS, ignore *.mod.c files
References: <1391612511-9276-1-git-send-email-prarit@redhat.com> <52F2533F.2020302@suse.cz> <52F253D6.2060100@redhat.com>
In-Reply-To: <52F253D6.2060100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-05 16:08, Prarit Bhargava wrote:
> 
> 
> On 02/05/2014 10:05 AM, Michal Marek wrote:
>> On 2014-02-05 16:01, Prarit Bhargava wrote:
>>> Add *.mod.c to the RCS_FIND_IGNORE in the top-level Makefile and to the ignore
>>> list in scripts/tags.sh.
>>
>>
>> This breaks make clean, which is supposed to remove the *.mod.c files.
>>
> 
> Michal,
> 
> Oops. :(.  So just the scripts/tags.sh needs to modified.  I'll resubmit just
> that patch unless you have a better suggestion.

Please directly change the find command in find_arch_sources() and
find_include_sources(), so that the $ignore variable is really
equivalent to $RCS_FIND_IGNORE. I'm actually wondering why we do not
simply use $RCS_FIND_IGNORE in the script.

Thanks,
Michal
