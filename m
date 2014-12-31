Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaLaOZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:25:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaLaOZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:25:10 -0500
Message-ID: <54A40743.8080401@suse.cz>
Date: Wed, 31 Dec 2014 15:25:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Ben Hutchings <ben@decadent.org.uk>, maximilian attems <max@stro.at>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>	<CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>	<1419619556.4705.136.camel@decadent.org.uk>	<54A40077.1080806@suse.cz> <CA+icZUWzEpgoQO8MEVF2PWOy-bQ9oYMdipBe3T+s2Os4tzKVZw@mail.gmail.com>
In-Reply-To: <CA+icZUWzEpgoQO8MEVF2PWOy-bQ9oYMdipBe3T+s2Os4tzKVZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-31 15:16, Sedat Dilek wrote:
> On Wed, Dec 31, 2014 at 2:56 PM, Michal Marek <mmarek@suse.cz> wrote:
>> The problem is that
>>
>>   clean-dirs += $(objtree)/debian/
>>
>> results in
>>
>>   clean-dirs += ./debian/
>>
>> and scripts/Makefile.clean treats it as relative to scripts/package.
>>
> 
> Thanks for your reply.
> 
> IIRC I looked through some commits touching this area.
> From your description, is the simplification ("kbuild: simplify build,
> clean, modbuiltin shorthands") in [1] the cause for this?

No, it broke with 7e1c0477 (kbuild: Use relative path for $(objtree)).

I'll problably change the logic in Makefile.clean to check for paths
starting with './' AKA '$(objtree)/', unless I find a more elegant solution.

Michal
