Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbaGRJj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbaGRJjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:39:24 -0400
Message-ID: <53C8EB45.20304@redhat.com>
Date: Fri, 18 Jul 2014 11:39:17 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
CC: linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1405633100-4889-1-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:38 PM, Theodore Ts'o wrote:
> 	If the GRND_RANDOM flags bit is set, then draw from the
> 	/dev/random pool instead of the /dev/urandom pool.  The
> 	/dev/random pool is limited based on the entropy that can be
> 	obtained from environmental noise, so if there is insufficient
> 	entropy, the requested number of bytes may not be returned.
> 	If there is no entropy available at all, getrandom(2) will
> 	either block, or return an error with errno set to EAGAIN if
> 	the GRND_NONBLOCK bit is set in flags.

Can we get a GRND_INIT flag or something like that which means 
"block/return EAGAIN until the kernel pool is initialized"?  Thanks.

(See the previous discussion about pool initialization.)

-- 
Florian Weimer / Red Hat Product Security
