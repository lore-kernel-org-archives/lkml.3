Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIXMHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:07:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIXMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:07:15 -0400
Message-ID: <5422B3EF.4000800@suse.cz>
Date: Wed, 24 Sep 2014 14:07:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: behanw@converseincode.com
CC: ak@linux.intel.com, yamada.m@jp.panasonic.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] kbuild, LLVMLinux: Add -Werror to cc-option to support
 clang
References: <1411500522-11480-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1411500522-11480-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-23 21:28, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Clang will warn about unknown warnings but will not return false

You mean unknown options, right?


> unless -Werror is set. GCC will return false if an unknown
> warning is passed.
> 
> Adding -Werror make both compiler behave the same.

Can you please limit it to the clang case? Add an internal variable that
either contains -Werror or nothing, depending on the compiler. What I
fear is that if we use -Werror unconditionally and the user (or some
automated build system) decides to add some silly option to KCFLAGS, we
will get silent failures in the cc-option tests. Of course, the same can
happen with clang, but there seems to be no way around it.

BTW, is there a chance that this would be fixed in some later clang
version? Accepting unknown commandline options is a rather unusual
behavior. How are all the ./configure scripts going to cope with it?

Thanks,
Michal
