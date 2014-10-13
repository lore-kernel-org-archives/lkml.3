Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaJMGsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:48:45 -0400
Received: from orange.myspectrum.nl ([149.210.134.247]:33574 "EHLO
	orange.myspectrum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJMGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:48:42 -0400
Message-ID: <543B75C7.60105@myspectrum.nl>
Date: Mon, 13 Oct 2014 08:48:39 +0200
From: Jeroen Hofstee <jeroen@myspectrum.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>, Jeroen Hofstee <jeroen@myspectrum.nl>
CC: linux-kbuild@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        lk <linux-kernel@vger.kernel.org>,
        U-Boot Mailing List <u-boot@lists.denx.de>
Subject: Re: [U-Boot] [PATCH resend] kconfig: Fix compiler warning in menu.c
References: <1413109527-10718-1-git-send-email-hdegoede@redhat.com>	<543AA8BF.7090809@myspectrum.nl> <CAPnjgZ1KvytMYp3RHkMiuW8x6_x4uf=GUUUMoL9RAGsgP_cXrQ@mail.gmail.com>
In-Reply-To: <CAPnjgZ1KvytMYp3RHkMiuW8x6_x4uf=GUUUMoL9RAGsgP_cXrQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Simon,

On 13-10-14 07:14, Simon Glass wrote:
> Hi Jeroen,
>
> On 12 October 2014 10:13, Jeroen Hofstee <jeroen@myspectrum.nl> wrote:
>
>> Hello Hans,
>>
>> On 12-10-14 12:25, Hans de Goede wrote:
>>
>>> Hi,
>>>
>>> This one seems to have fallen through the cracks.
>>>
>>> Regards,
>>>
>>> Hans
>>>
>>>   (for U-boot)
>> nope, you replace an innocent warning (_might_ be) with
>> bad code, without any comment it is just because gcc failed
>> to recognize it is fine. Nor did you respond to the suggestion
>> if it helps gcc to recognize that if the two booleans are merged
>> into a single one. [or even split it in an if () if ()]. With this patch
>> you prevent any serious warning in case the variable is actually
>> used but not initialized, which is even worse if you ask me.
>>
> That is a pretty acerbic tone to take on the U-Boot list at least. Are you
> two drinking buddies or something?

no, it is because we have discussed this patch before and resending
it won't address the issue raised. But you are right, it is likely done with
less evil intends then I took it for, so let me explain my concern again
in a politer way. The problem is that gcc 4.9 starts warning in the
following case:

int *ptr;

if (a)
     ptr = something;

if (a && b)
     ptr->bla = value;
else
    do_something_else();


it will warn that ptr _might_ be used uninitialized (but it always is).
This is fixed in this patch by assigning NULL to ptr, and while that makes
the warning go away it actually prevents the valid warning, ptr _is_ used
uninitialized if you start using it in the else case. Hence my request if we
can't find a better solution for this.

Does anyone know a better solution for this or should we consider
disabling the might be unused warning?

Regards,
Jeroen

