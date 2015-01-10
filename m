Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbbAJI1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:27:53 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54586 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbAJI1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:27:51 -0500
Message-ID: <54B0E282.7090203@gmail.com>
Date: Sat, 10 Jan 2015 09:27:46 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, Rich Felker <dalias@aerifal.cx>
CC: mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
References: <1416830039-21952-1-git-send-email-drysdale@google.com> <1416830039-21952-6-git-send-email-drysdale@google.com> <54AFF813.7050604@gmail.com> <20150109161302.GQ4574@brightrain.aerifal.cx> <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
In-Reply-To: <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 06:46 PM, David Drysdale wrote:
> On Fri, Jan 9, 2015 at 4:13 PM, Rich Felker <dalias@aerifal.cx> wrote:
>> On Fri, Jan 09, 2015 at 04:47:31PM +0100, Michael Kerrisk (man-pages) wrote:
>>> On 11/24/2014 12:53 PM, David Drysdale wrote:
>>>> Signed-off-by: David Drysdale <drysdale@google.com>
>>>> ---
>>>>  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 153 insertions(+)
>>>>  create mode 100644 man2/execveat.2
>>>
>>> David,
>>>
>>> Thanks for the very nicely prepared man page. I've done
>>> a few very light edits, and will release the version below
>>> with the next man-pages release.
>>>
>>> I have one question. In the message accompanying
>>> commit 51f39a1f0cea1cacf8c787f652f26dfee9611874 you wrote:
>>>
>>>   The filename fed to the executed program as argv[0] (or the name of the
>>>   script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
>>>   (for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
>>>   reflecting how the executable was found.  This does however mean that
>>>   execution of a script in a /proc-less environment won't work; also, script
>>>   execution via an O_CLOEXEC file descriptor fails (as the file will not be
>>>   accessible after exec).
>>>
>>> How does one produce this situation where the execed program sees
>>> argv[0] as a /dev/fd path? (i.e., what would the execveat()
>>> call look like?) I tried to produce this scenario, but could not.
>>
>> I think this is wrong. argv[0] is an arbitrary string provided by the
>> caller and would never be derived from the fd passed.
> 
> Yeah, I think I just wrote that wrong, it's only relevant for scripts.
> As Rich says, for normal binaries argv[0] is just the argv[0] that
> was passed into the execve[at] call.  For a script, the code in
> fs/binfmt_script.c will remove the original argv[0] and put the
> interpreter name and the script filename (e.g. "/bin/sh",
> "/dev/fd/6/script") in as 2 arguments in its place.

So, on reflection, I think it's worth saying something about this, and 
I added the following text to the man page:

   NOTES
       When asked to execute a script file, the argv[0] that  is  passed
       to  the  script  interpreter is a string of the form /dev/fd/N or
       /dev/fd/N/P, where N is the number of the file descriptor  passed
       via  the  dirfd argument.  A string of the first form occurs when
       AT_EMPTY_PATH is employed.  A string of the  second  form  occurs
       when the script is specified via both dirfd and pathname; in this
       case, P is the value given in pathname.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
