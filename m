Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3IEPhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:37:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40453 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab3IEPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:37:07 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1378353524.13193.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com> <5227FFE8.5050102@zytor.com> <1378353524.13193.26.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module security is enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 05 Sep 2013 08:36:51 -0700
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Message-ID: <69eec644-f26f-410c-bb76-0b7695dde65c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh.  That capability really is fscked up.

Matthew Garrett <matthew.garrett@nebula.com> wrote:
>On Wed, 2013-09-04 at 20:52 -0700, H. Peter Anvin wrote:
>> On 09/03/2013 04:50 PM, Matthew Garrett wrote:
>> > IO port access would permit users to gain access to PCI
>configuration
>> > registers, which in turn (on a lot of hardware) give access to MMIO
>register
>> > space. This would potentially permit root to trigger arbitrary DMA,
>so lock
>> > it down by default.
>> > 
>> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
>> 
>> Seriously... just deny CAP_SYS_RAWIO to any system in secure mode.
>
>No. CAP_SYS_RAWIO blocks things that we don't want blocked (x86
>microcode updates, various disk ioctls, *device firmware uploads* and a
>few others) - the semantics just don't match. We could relax those
>permissions, but then we'd potentially break someone else's security
>considerations.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
