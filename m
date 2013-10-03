Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3JCWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:47:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab3JCWrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:47:22 -0400
Message-ID: <524DF3DA.7060204@zytor.com>
Date: Thu, 03 Oct 2013 15:46:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Aaron Durbin <adurbin@google.com>,
        Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>,
        Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 3/7] x86, kaslr: find minimum safe relocation position
References: <1380833605-26313-1-git-send-email-keescook@chromium.org> <1380833605-26313-4-git-send-email-keescook@chromium.org> <524DEE6B.2060105@zytor.com> <CAGXu5j+hm8whuGxJ9PBEdxrSwpdH9a-S5-7ReVmb+COyRo9=uw@mail.gmail.com>
In-Reply-To: <CAGXu5j+hm8whuGxJ9PBEdxrSwpdH9a-S5-7ReVmb+COyRo9=uw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 03:43 PM, Kees Cook wrote:
>> This is highly problematic.  The standard protocol is to hoist the
>> initramfs as high as possible in memory, so this may really unacceptably
>> restrict the available range.
> 
> Doesn't this depend on the boot loader's behavior?

It does, but the recommended (and *required* for compatibility with
older kernels) behavior is to hoist as high as possible.

>> It would be better to treat these the same as reserved regions in the
>> e820 map as far as the address space picking algorithm is concerned.
> 
> Could this be considered a future optimization, or do you feel this is
> required even for this first patch series landing?

Yes, I consider it required because of the above.

	-hpa


