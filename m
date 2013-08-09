Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968107Ab3HIS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:27:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075Ab3HIS1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:27:35 -0400
Message-ID: <52053485.7070902@zytor.com>
Date: Fri, 09 Aug 2013 11:27:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
CC: Jan Engelhardt <jengelh@inai.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>
Subject: Re: [PATCH] depmod: add missing "else" clause
References: <1375912738-25114-1-git-send-email-jengelh@inai.de> <1375912738-25114-2-git-send-email-jengelh@inai.de> <CAKi4VA+-NnohHc5cMirN=B5uizLQBDnaZ5Aiq24AFe=puFDNJg@mail.gmail.com>
In-Reply-To: <CAKi4VA+-NnohHc5cMirN=B5uizLQBDnaZ5Aiq24AFe=puFDNJg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 08:03 AM, Lucas De Marchi wrote:
> Hi Jan,
> 
> 
> On Wed, Aug 7, 2013 at 6:58 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> It occurred to an openSUSE user that our mkinitrd would throw a
>> warning when used with kmod:
>>
>> libkmod: conf_files_list: unsupported file mode /dev/null: 0x21b6
>>
>> Grepping for the error message revealed that there might be a missing
>> "else" keyword here, since it is unusual to put an "if" directly after
>> closing brace.
>> ---
>>  libkmod/libkmod-config.c | 2 +-
>>  tools/depmod.c           | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/libkmod/libkmod-config.c b/libkmod/libkmod-config.c
>> index 201c349..cb4cf61 100644
>> --- a/libkmod/libkmod-config.c
>> +++ b/libkmod/libkmod-config.c
>> @@ -833,7 +833,7 @@ static int conf_files_list(struct kmod_ctx *ctx, struct kmod_list **list,
>>         if (S_ISREG(st.st_mode)) {
>>                 conf_files_insert_sorted(ctx, list, path, NULL);
>>                 return 0;
>> -       } if (!S_ISDIR(st.st_mode)) {
>> +       } else if (!S_ISDIR(st.st_mode)) {
>>                 ERR(ctx, "unsupported file mode %s: %#x\n",
>>                                                         path, st.st_mode);
>>                 return -EINVAL;
>> diff --git a/tools/depmod.c b/tools/depmod.c
>> index 4a02631..985cf3a 100644
>> --- a/tools/depmod.c
>> +++ b/tools/depmod.c
>> @@ -848,7 +848,7 @@ static int cfg_files_list(struct cfg_file ***p_files, size_t *p_n_files,
>>         if (S_ISREG(st.st_mode)) {
>>                 cfg_files_insert_sorted(p_files, p_n_files, path, NULL);
>>                 return 0;
>> -       } if (!S_ISDIR(st.st_mode)) {
>> +       } else if (!S_ISDIR(st.st_mode)) {
>>                 ERR("unsupported file mode %s: %#x\n", path, st.st_mode);
>>                 return -EINVAL;
>>         }
>> --
> 
> Applied, thanks.
> 
> Please make sure to CC linux-modules@vger.kernel.org
> 

Also please note that this is a stylistic change only, since the
previous if clause ends with a return.

	-hpa


