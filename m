Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3ANTA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:00:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3ANTA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:00:56 -0500
Message-ID: <50F455A3.4070706@zytor.com>
Date: Mon, 14 Jan 2013 10:59:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-23-git-send-email-yinghai@kernel.org> <20130113214132.GB17200@liondog.tnic> <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com> <50F4452D.2060000@zytor.com> <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
In-Reply-To: <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 10:57 AM, Yinghai Lu wrote:
>>
>> If the sentinel is flagged, zero *all fields not explicitly set by the
>> broken versions of kexec*, not just your new "ext" fields.
> 
> other fields are pad* fields, so do we zero out them
> with memset with exact address?
> so next times, when someone change pad fields to other ext_*,
> they don't need to change code again here.
> 

No, there were other fields that were also left uninitialized, per your
analysis from last year.  I don't remember the details, but I seem to
recall they included the EFI and graphics-related fields.

So yes, just zero them all out.

	-hpa


