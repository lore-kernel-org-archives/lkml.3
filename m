Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaJBDvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:51:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43955 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaJBDvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:51:53 -0400
Message-ID: <542CCBCB.9000709@oracle.com>
Date: Wed, 01 Oct 2014 23:51:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>	<20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>	<542C749B.1040103@oracle.com> <20141001144834.ff3ff0349951df734d159fb3@linux-foundation.org>
In-Reply-To: <20141001144834.ff3ff0349951df734d159fb3@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 05:48 PM, Andrew Morton wrote:
> On Wed, 01 Oct 2014 17:39:39 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>>> It looks fairly cheap - I wonder if it should simply fall under
>>> CONFIG_DEBUG_VM rather than the new CONFIG_DEBUG_VM_POISON.
>>
>> Config options are cheap as well :)
> 
> Thing is, lots of people are enabling CONFIG_DEBUG_VM, but a smaller
> number of people will enable CONFIG_DEBUG_VM_POISON.  Less coverage. 
> 
> Defaulting to y if CONFIG_DEBUG_VM might help, but if people do `make
> oldconfig' when CONFIG_DEBUG_VM=n, their CONFIG_DEBUG_VM_POISON will
> get set to `n' and will remain that way when they set CONFIG_DEBUG_VM
> again.

In that case, what about:

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index db41b15..b2c7038 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -546,6 +546,7 @@ config DEBUG_VM_RB
 config DEBUG_VM_POISON
        bool "Poison VM structures"
        depends on DEBUG_VM
+       def_bool y
        help
          Add poison to the beggining and end of various VM structure to
          detect memory corruption in VM management code.

We'll default to "Y" in 'make oldconfig' and it'll automatically be switched
on when the user selects CONFIG_DEBUG_VM=y, but we still keep the advantages
of having it in a different config option.


Thanks,
Sasha

