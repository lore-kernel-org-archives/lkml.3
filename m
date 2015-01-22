Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbbAVCNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:13:01 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52402 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbAVCMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:12:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150121125820.GA8244@dhcp128.suse.cz>
References: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com> <20150121125820.GA8244@dhcp128.suse.cz>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 21 Jan 2015 21:12:23 -0500
Message-ID: <CAJhHMCDjKGunTDuU7Rgtk2CH2ZENJ8Zbzvzuoj2hwLDnd6rbVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
To: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Joe Perches <joe@perches.com>, John Stultz <john.stultz@linaro.org>,
        Dan Streetman <ddstreet@ieee.org>,
        =?UTF-8?B?U2ltb24gS8OlZ3N0csO2bQ==?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 7:58 AM, Petr Mladek <pmladek@suse.cz> wrote:
> On Tue 2015-01-20 18:51:49, Pranith Kumar wrote:
>> There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
>> for when CONFIG_PRINTK is not set causing build failures.
>>
>> This patch adds these dummy routines at the appropriate location.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> CC: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  include/linux/printk.h | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/printk.h b/include/linux/printk.h
>> index aeb9d7f..f52f02b 100644
>> --- a/include/linux/printk.h
>> +++ b/include/linux/printk.h
>> @@ -10,9 +10,6 @@
>>  extern const char linux_banner[];
>>  extern const char linux_proc_banner[];
>>
>> -extern char *log_buf_addr_get(void);
>> -extern u32 log_buf_len_get(void);
>> -
>>  static inline int printk_get_level(const char *buffer)
>>  {
>>       if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
>> @@ -168,6 +165,8 @@ void __init setup_log_buf(int early);
>>  void dump_stack_set_arch_desc(const char *fmt, ...);
>>  void dump_stack_print_info(const char *log_lvl);
>>  void show_regs_print_info(const char *log_lvl);
>> +char *log_buf_addr_get(void);
>> +u32 log_buf_len_get(void);
>>  #else
>>  static inline __printf(1, 0)
>>  int vprintk(const char *s, va_list args)
>> @@ -217,6 +216,16 @@ static inline void dump_stack_print_info(const char *log_lvl)
>>  static inline void show_regs_print_info(const char *log_lvl)
>>  {
>>  }
>> +
>> +static inline char *log_buf_addr_get(void)
>> +{
>> +     return NULL;
>> +}
>> +
>> +static linline u32 log_buf_len_get(void)
>           ^
>           typo: linline -> inline

Argh, shows why we should always atleast build test before sending a
patch, no matter how trivial it is.

>
> Otherwise, it looks fine to me.
>
> Well, If you send v2, I would move this above log_buf_kexec_setup() in
> both #ifdef branches. So that all four log_buf()-related functions
> declared/defined together.

I will update as you said in v2.

Thanks!
-- 
Pranith
