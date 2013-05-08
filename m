Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3EHIcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:32:51 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:60095 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3EHIcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:32:48 -0400
Message-ID: <518A0DA5.4060001@hauke-m.de>
Date: Wed, 08 May 2013 10:32:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Dropping non supported kernels for kernel backports ?
References: <CAB=NE6Wy0dp51wDxKzo74Kz=2F-MQjOnARS1r-z3v+LrOwhn-Q@mail.gmail.com>  (sfid-20130508_015436_904346_B7B59A0B) <1367996104.8279.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367996104.8279.5.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 08:55 AM, Johannes Berg wrote:
> On Tue, 2013-05-07 at 16:53 -0700, Luis R. Rodriguez wrote:
>> Today the backports project provides support to backport down to
>> 2.6.24 for some subsystems. While this is good for users in practice
>> for development and maintenance this is quite a bit of overhead. Apart
>> from older kernels there are also gaps in between stable releases that
>> are not supported. For example 3.8 and 3.4 are supported but anything
>> in between is not (3.5, 3.6, 3.7), but we still do support them on the
>> backports project. At times this may mean a stable fix may get
>> propagated onto a the linux-3.4.y branch but obviously not the the
>> linux-3.5.y branch. If backporting expressing this becomes a bit
>> complex and we have dealt with it. In short, its a pain.
>>
>> I'd like to see what folks thought if we went ahead and *only*
>> supported kernels listed on kernel.org as supported. This would help
>> with the Linux kernel maintainer effort by also persuading users to
>> upgrade to stable releases as well as educating around this.
>>
>> If v3.10 backported releases are too soon to do this I propose we
>> seriously consider it for v3.11 releases. Any thoughts?
> 
> I'm sure I'd still have to support other kernels random customers might
> be on (customers, they don't always do the smart thing ;-) ). I could do
> that myself of course, but then where would I stick the support patches?
> 
> Maybe we could do a compromise and drop support for no longer supported
> kernels, but only a few years later? If we put the cutoff at 3 years now
> we'd drop everything before 2.6.34, for example.
> 
> johannes

I it is not often that something compat depends on gets backported into
some longterm kernel. The majority ~90% of backports added to compat are
not backported to any longterm kernel. If we want to support some kernel
version I do not think it is a hard task to support the versions in between.

Instead of supporting everything back to 2.6.34 I would like to got to
2.6.32 because this was used in Debian squeeze, RedHat 6 and some Ubuntu
long term version.

Dropping support for kernel versions not older than a year but not
supported any more is a bad idea, because the big distributions often
pick a non longterm kernel as their distribution kernel. Than we would
not even support the recent Ubuntu versions for a long time. Ubuntu
12.10 uses kernel 3.5 and Ubuntu 13.04 uses 3.8, both are no longterm
kernel versions.

Hauke
