Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3ANXLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:11:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59713 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093Ab3ANXLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:11:14 -0500
Message-ID: <50F49061.1040805@zytor.com>
Date: Mon, 14 Jan 2013 15:10:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
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
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-23-git-send-email-yinghai@kernel.org> <20130113214132.GB17200@liondog.tnic>
In-Reply-To: <20130113214132.GB17200@liondog.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2013 01:41 PM, Borislav Petkov wrote:
>> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
>> index b4c913c..bffd73b 100644
>> --- a/arch/x86/boot/compressed/cmdline.c
>> +++ b/arch/x86/boot/compressed/cmdline.c
>> @@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
>>  {
>>  	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
>>  
>> +	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
>> +
>>  	return cmd_line_ptr;
>>  }
> 
> On 32-bit, this unsigned long cmd_line_ptr is 4 bytes and the OR doesn't
> have any effect on the final result. You probably want to do:
> 
> #ifdef CONFIG_64BIT
> 	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
> #endif
> 
> right?
> 

Actually, on 32 bits the compiler will simply drop the statement on the
floor, no #ifdef required.  If gcc outputs a warning we should do
something about it, otherwise we can just plain ignore it.

	-hpa


