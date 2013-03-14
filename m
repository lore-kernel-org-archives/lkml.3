Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3CNJVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:21:16 -0400
Received: from multi.imgtec.com ([194.200.65.239]:48354 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab3CNJVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:21:14 -0400
Message-ID: <51419686.7080405@imgtec.com>
Date: Thu, 14 Mar 2013 09:21:10 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        "Sam Ravnborg" <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Kliegman <kliegs@chromium.org>
Subject: Re: [PATCH 1/1] module: fix symbol versioning with symbol prefixes
References: <1363100964-29982-1-git-send-email-james.hogan@imgtec.com> <8738vyvoy0.fsf@rustcorp.com.au>
In-Reply-To: <8738vyvoy0.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_14_09_21_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 23:51, Rusty Russell wrote:
> James Hogan <james.hogan@imgtec.com> writes:
>> Fix symbol versioning on architectures with symbol prefixes. Although
>> the build was free from warnings the actual modules still wouldn't load
>> as the ____versions table contained unprefixed symbol names, which were
>> being compared against the prefixed symbol names when checking the
>> symbol versions.
>>
>> This is fixed by modifying modpost to add the symbol prefix to the
>> ____versions table it outputs (Modules.symvers still contains unprefixed
>> symbol names). The check_modstruct_version() function is also fixed as
>> it checks the version of the unprefixed "module_layout" symbol which
>> would no longer work.
> 
> Hmm, this has always been broken, right?  And noone noticed?  Unless you
> really want it now, I'll queue it for *next* merge window.

Yes, that's fine by me.

> I've applied it (reworked) to my pending-rebases queue, and will put it
> in modules-next once the cleanup goes in.

Thanks
James

