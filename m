Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3CAMuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:50:51 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64211 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CAMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:50:49 -0500
Message-ID: <5130A43C.9040207@suse.cz>
Date: Fri, 01 Mar 2013 13:51:08 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net, ML netdev <netdev@vger.kernel.org>
Subject: e1000e broken after resume on x230 [was: Uhhuh. NMI received for
 unknown reason 2c on CPU 0.]
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic> <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com> <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>
In-Reply-To: <511DF7B4.8060504@openvz.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 09:54 AM, Konstantin Khlebnikov wrote:
> Borislav Petkov wrote:
>> On Thu, Feb 14, 2013 at 10:17:46AM -0700, Bjorn Helgaas wrote:
>>> It's pretty late for v3.8, but let me know if you think they're
>>> critical.
>>
>> Ok, I meant those:
>>
>> http://marc.info/?l=linux-kernel&m=135984592927219
>>
>> They fix the link detection issue on my x230. So let's see. The first
>> one is:
>>
>> * https://patchwork.kernel.org/patch/2001211/ (e1000e: fix pci device
>> enable
>> counter balance)
> 
> please use this instead:

Hi, I am a bit confused. Is this fixed in -next yet? And if so, is it
known which commit IDs are needed to fix the issue in 3.7 (see below)?

> [PATCH v2 1/7] e1000e: fix pci-device enable-counter balance
> https://lkml.org/lkml/2013/2/4/190
> 
> from v2 patchset: https://lkml.org/lkml/2013/2/4/185

So this is now in -next as:
commit e34f7147d93afe5efc574734bbff6584c0cc4a02
Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date:   Mon Feb 25 09:19:04 2013 +0400

    e1000e: fix pci-device enable-counter balance

>> I don't see that one in your tree.
>>
>> * pci-pm-clear-state_saved-during-suspend.patch

This is:
commit 82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon Feb 4 15:56:05 2013 +0400

    PCI/PM: Clear state_saved during suspend

>> Rafael said this one is a real bugfix. Looks like e1000e maintainers are
>> picking that one?
>>
>> * pci-pm-fix-e1000e-runtime-suspend.patch

Is this one replaced by a different fix in the end? Which one? I don't
think it is in -next yet, right?

confused,
-- 
js
suse labs
