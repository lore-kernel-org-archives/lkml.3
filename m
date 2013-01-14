Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3ANXuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:50:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3ANXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:50:48 -0500
Message-ID: <50F499BA.4090403@zytor.com>
Date: Mon, 14 Jan 2013 15:50:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>  <50F46E77.4070500@zytor.com>  <CAE9FiQVajL=XE7q5KckN6JQZJi2gvbnB1EDadfW6MFW37OoKWQ@mail.gmail.com>  <50F491E2.8090907@zytor.com> <1358206790.2397.13.camel@shinybook.infradead.org>
In-Reply-To: <1358206790.2397.13.camel@shinybook.infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 03:39 PM, David Woodhouse wrote:
> On Mon, 2013-01-14 at 15:16 -0800, H. Peter Anvin wrote:
>> The reason I want to do this this way is that I want to also make
>> David Woodhouse's protocol fixes to make the EFI stub work correctly
>> at the same time, so we get a single protocol level bump. 
> 
> My changes don't need a protocol level bump. It's just two new bits in
> load_flags that old loaders won't care about.
> 

I'm wondering if we should put your new flags in xloadflags instead just
because some boot loaders have been known to clobber the loadflags when
setting the upper bits.  In theory it shouldn't matter... I'm wondering
if it does in practice.  The other bit is that Yinghai's changes want
even more flags.

Either way might as well see if we can do it as closely adjacently as
possible (but no, I don't want to drag this out.)

	-hpa

