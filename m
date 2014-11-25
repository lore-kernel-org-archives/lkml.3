Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKYBw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:52:57 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48117 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaKYBw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:52:56 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Nov 2014 17:52:34 -0800
Message-ID: <CALCETrWS6-DAyQyHbouXqgEwmaOjxMhFGudV7zsXb9_-mK2TPQ@mail.gmail.com>
Subject: IST stack patches v3.5
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tagged v3.5 of my paranoid stack code.  It's in a strange state right now:

Patch 1 (the actual stack switching) is standalone.  It's not really a
good base for the memory failure stuff, because all of the ist_enter
stuff is missing.  It should *work*, but the result will be ugly.
OTOH, it should be okay as a base for fsgsbase.

Patch 2 is from Paul McKenney.  It fixes RCU NMI nesting, which is a
prerequisite for ist_enter.  I think that the current plan is for that
to happen in 3.20.  Speak up if you want it sooner.

Patch 4 is purely for testing.  It forces "NMIs" to nest.

"x86, mce: Improve timeout error messages" is in there so I don't
forget about it.  Tony and Borislav, if you like it, want to pick it
up?  It really has very little to do with the rest of this code.

The remainder of the non-atomic IST stuff is in there in a plausibly
final form, but it's oddly based.

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
