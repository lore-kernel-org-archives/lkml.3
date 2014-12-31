Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbbAEMNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:13:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbbAEMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:13:19 -0500
Message-ID: <54A3FFCA.9030501@suse.cz>
Date: Wed, 31 Dec 2014 14:53:14 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, sedat.dilek@gmail.com
CC: maximilian attems <max@stro.at>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>	 <CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com> <1419619556.4705.136.camel@decadent.org.uk>
In-Reply-To: <1419619556.4705.136.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-26 19:46, Ben Hutchings wrote:
> On Fri, 2014-12-26 at 13:43 +0100, Sedat Dilek wrote:
>> On Fri, Dec 26, 2014 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> [...]
>>>
>>> Any other make (PHONY) target I don't know?
>>>
>>
>> I fell over "clean-dirs"...
>>
>> scripts/package/Makefile:93:clean-dirs += $(objtree)/debian/
>>
>> ...but did not really understood how it works.
>> The main Makefile defines some clean-dirs PHONY#s.
>> I can only speculate, someone with more skillz in Makefile handling
>> should look at this.
> 
> It looks like this has not worked for a long time.  The scripts
> directory is not included in the main recursive processes; it seems to
> be special-cased for build and not for clean.

It actually is special-cased for mrproper, which is a subset if
distclean. The real problem is that

clean-dirs += $(objtree)/debian/

expands to

clean-dirs += ./debian/

and scripts/Makefile.clean things that this is relative to the
scripts/package directory.

Michal
