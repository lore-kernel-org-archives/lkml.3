Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3JYNiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:38:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127Ab3JYNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:38:53 -0400
Message-ID: <526A746C.3060806@free-electrons.com>
Date: Fri, 25 Oct 2013 15:38:52 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: mmarek@suse.cz, yann.morin.1998@free.fr, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com> <1382599849.22433.51.camel@joe-AO722>
In-Reply-To: <1382599849.22433.51.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thank you very much for your review!

On 10/24/2013 09:30 AM, Joe Perches wrote:
> On Thu, 2013-10-24 at 07:23 +0200, Michael Opdenacker wrote:
>
>> +def count_param(param):
>> +
>> +    global source_file, bad_params_in_file
>> +
>> +    if os.path.isdir('.git'):
>> +       # Use git grep when available
>> +       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)
>> +    else:
>> +       # Fallback to regular grep
>> +       count = subprocess.check_output('grep -R ' + param + ' . | grep -v defconfig | wc -l', shell=True)
> Doesn't the grep need -w?
Using "-w" is a good idea, and this way I can eliminate false negatives
(for example finding matches for "PRINTK_TIME" when I'm looking for
plain "PRINTK"). The only this is that I then need to look for both
"PARAM" (in Kconfig files, in case the parameter is just used for
dependency management), and for "CONFIG_PARAM" (in source files).
>
> Also, the regular grep could probably use something like
> 'grep -R -w --max-count=2 --include="*.[chS]"'
I can definitely use "--max-count=2".

 '--include="*.[chS]"' is more problematic because it excludes Kconfig
files. I'll use "-I" instead to just ignore binary files.

I'll soon send an update taking this into account.

Don't hesitate to send more comments.

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

