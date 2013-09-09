Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3IIS1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:27:15 -0400
Received: from mail.lang.hm ([64.81.33.126]:54932 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab3IIS1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:27:12 -0400
Date: Mon, 9 Sep 2013 11:25:38 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: <19562.1378747124@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 09 Sep 2013 11:49:34 -0400, Matthew Garrett said:
>
>> So, this is my final attempt at providing the functionality I'm interested
>> in without inherently tying it to Secure Boot. There's strong parallels
>> between the functionality that I'm interested in and the BSD securelevel
>> interface, so here's a trivial implementation.
>
> Although all the individual patches look like sane and reasonable things
> to do, I'm not at all convinced that sticking them all under control of one
> flag is really the right way to do it.  In particular, there probably needs
> to be some re-thinking of the kexec, signed-module, and secure-boot stuff,
> as it's still a moving target.

Given that we know that people want signed binaries without blocking kexec, you 
should have '1' just enforce module signing and '2' (or higher) implement a full 
lockdown including kexec.

Or, eliminate the -1  permanently insecure option and make this a bitmask, if 
someone wants to enable every possible lockdown, have them set it to "all 1's", 
define the bits only as you need them.

right now
1 lock down modules
2 lock down kexec

etc

you may also want to have a 'disable module loading after this point' in the 
future.

David Lang
