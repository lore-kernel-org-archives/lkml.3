Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3DYWBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:01:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3DYWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:01:23 -0400
Message-ID: <5179A797.9040200@zytor.com>
Date: Thu, 25 Apr 2013 15:00:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
References: <1366926860-26776-1-git-send-email-keescook@chromium.org> <1366926860-26776-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-3-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 02:54 PM, Kees Cook wrote:
> Since has_eflag() and has_fpu() are 32-bit only, short-circuit the
> routines on 64-bit when they are built without -m32. This also refactors
> the calls to cpuid to make them PIC-safe on 32-bit.

These functions can trivially be made 32- and 64-bit agnostic by
changing "u32" to "unsigned long" and drop the -l suffixes in the
assembly code.

	-hpa

