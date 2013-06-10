Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3FJW0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:26:30 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41533 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3FJW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <51B30285.6020503@asianux.com>
References: <51B30285.6020503@asianux.com>
Date: Mon, 10 Jun 2013 15:26:26 -0700
Message-ID: <CA+8MBbK_nfOhZGsd5wU-hyiwh3pHS5c42eiBfxLpCjDgBKUqJg@mail.gmail.com>
Subject: Re: [Suggestion] arch/*/include/asm/bitops.h: about __set_bit() API.
From: Tony Luck <tony.luck@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Richard Henderson <rth@twiddle.net>, ink@jurassic.park.msu.ru,
        Matt Turner <mattst88@gmail.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, yasutake.koichi@jp.panasonic.com,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        linux-am33-list@redhat.com, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 3:08 AM, Chen Gang <gang.chen@asianux.com> wrote:
> using 'unsigned int *', implicitly:
>   ./ia64/include/asm/bitops.h:63:__set_bit (int nr, volatile void *addr)

There is some downside on ia64 to your suggestion.  If "addr" is properly
aligned for an "int", but misaligned for a long ... i.e. addr%8 == 4, then I'll
take an unaligned reference trap if I work with long* where the current code
working with int* does not.

Now perhaps all the callers do guarantee long* alignment?  But I don't know.

Apart from uniformity, there doesn't see to be any upside to changing this.

-Tony Luck
