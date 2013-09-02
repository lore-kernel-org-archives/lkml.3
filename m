Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3IBPqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:46:48 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:37132 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3IBPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:46:46 -0400
Message-ID: <5224B2BE.7070001@gmail.com>
Date: Mon, 02 Sep 2013 17:46:06 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: kmemleak disables all CPUs except CPU0
References: <5221F119.4070000@gmail.com> <CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com>
In-Reply-To: <CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Catalin Marinas wrote:
> On 31 August 2013 14:35, Martin MOKREJŠ <mmokrejs@gmail.com> wrote:
>>   never realized that my CPUs are gone if I compile into kernel kmemleak.
>> Is that really the aim?
>>
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>>
>> 1.  Why isn't there /sys/devices/system/cpu/cpu0/online file?
>> Does not matter if it contains 0 or 1. It just should exist.
> 
> I can't really see how kmemleak would do this, maybe other config
> options that get set/cleared in the process of selecting kmemleak. Can
> you do a diff between your config with /sys/... entries and the one
> without?

Hi,
  I tried but did not get to report back. One one these re-enabled my CPUs back.

@@ -3177,14 +3179,7 @@
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
 CONFIG_HAVE_ARCH_KMEMCHECK=y
-CONFIG_KMEMCHECK=y
-# CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT is not set
-# CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT is not set
-CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT=y
-CONFIG_KMEMCHECK_QUEUE_SIZE=64
-CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT=5
-CONFIG_KMEMCHECK_PARTIAL_OK=y
-# CONFIG_KMEMCHECK_BITOPS_OK is not set
+# CONFIG_KMEMCHECK is not set
 # CONFIG_TEST_STRING_HELPERS is not set
 # CONFIG_TEST_KSTRTOX is not set
 # CONFIG_STRICT_DEVMEM is not set


So, the CONFIG_KMEMCHECK disables the additional CPUs I believe. I thought it
should be traceable from the dmesg output I sent to the list. Yes, I screwed the
subject line because I did not realize a difference so far. :(

Martin
