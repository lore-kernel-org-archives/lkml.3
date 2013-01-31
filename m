Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AaKu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:50:57 -0500
Received: from multi.imgtec.com ([194.200.65.239]:61519 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3AaKu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:50:56 -0500
Message-ID: <510A4C82.8090806@imgtec.com>
Date: Thu, 31 Jan 2013 10:50:42 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        "Mike Frysinger" <vapier@gentoo.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
References: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com> <510A4967.5070009@suse.cz>
In-Reply-To: <510A4967.5070009@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_31_10_50_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 31/01/13 10:37, Michal Marek wrote:
> On 31.1.2013 10:41, James Hogan wrote:
>> On architectures which have symbol prefixes, depmod emits lots of false
>> warnings like this:
>>
>> WARNING: $module.ko needs unknown symbol $symbol
>>
>> This is because depmod isn't being passed the -P <symbol_prefix>
>> arguments to specify the symbol prefix to ignore. This option is
>> included since the 3.13 release of module-init-tools.
>>
>> Update scripts/depmod.sh to take extra arguments which are passed
>> through directly to depmod, and update the main Makefile to pass
>> -P $(CONFIG_SYMBOL_PREFIX to scripts/depmod.sh, but only if
>> CONFIG_SYMBOL_PREFIX is set and non-empty.
> 
> OK.
> 
> 
>> scripts/depmod.sh also drops the -P arguments if depmod --version
>> reports module-init-tools with a version number < 3.13.
> 
> You can replace the test with a simple
> 
> "$DEPMOD" -P _ --help 2>/dev/null >/dev/null

Thanks for the suggestion. It would be much cleaner, but unfortunately I
tried this on module-init-tools 3.3-pre2 and module-init-tools 3.9 and
both still return success.

Cheers
James

