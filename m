Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaHCF13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 01:27:29 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55407 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHCF11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 01:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVhmcSqAR413hA8Ro0j2x54snt9Pj5Q_VVQLtea7Xr1jBQ@mail.gmail.com>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
	<20140803035931.GA24059@mguzik.redhat.com>
	<CAPDOMVh16no_Lh=4cPEpXJheCU67DJJS6EBtg9AH_0yUXxXSPg@mail.gmail.com>
	<20140803050221.GA31553@mguzik>
	<CAPDOMVhmcSqAR413hA8Ro0j2x54snt9Pj5Q_VVQLtea7Xr1jBQ@mail.gmail.com>
Date: Sun, 3 Aug 2014 01:27:26 -0400
Message-ID: <CAPDOMVjvJsvFkJW7FdM+77-oh5h7WGs7=X80Vk_oScMcSA+fpA@mail.gmail.com>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef statement
 in sg_set_bf
From: Nick Krause <xerofoify@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 1:18 AM, Nick Krause <xerofoify@gmail.com> wrote:
> On Sun, Aug 3, 2014 at 1:02 AM, Mateusz Guzik <mguzik@redhat.com> wrote:
>> On Sun, Aug 03, 2014 at 12:31:30AM -0400, Nick Krause wrote:
>>> On Sat, Aug 2, 2014 at 11:59 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
>>> > On Sat, Aug 02, 2014 at 10:56:13PM -0400, Nicholas Krause wrote:
>>> >> This changes the ifdef statement in sg_set_bg to !CONFIG_DEBUG_SG in order
>>> >> to avoid a bug with xhci dequence/enquence functions.
>>> >>
>>> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> >> ---
>>> >>  include/linux/scatterlist.h | 2 +-
>>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >>
>>> >> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>>> >> index adae88f..62de7b3 100644
>>> >> --- a/include/linux/scatterlist.h
>>> >> +++ b/include/linux/scatterlist.h
>>> >> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
>>> >>  static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>>> >>                             unsigned int buflen)
>>> >>  {
>>> >> -#ifdef CONFIG_DEBUG_SG
>>> >> +#ifdef !CONFIG_DEBUG_SG
>>> >>       BUG_ON(!virt_addr_valid(buf));
>>> >>  #endif
>>> >
>>> > Have you tried compiling this? IIRC you said you would compile your
>>> > stuff, what hapened to that?
>>> >
>>> > What exactly were you trying to achieve? Did this BUG_ON detect a
>>> > problem on your system and now you are trying to silence it?
>>> >
>>> > The change would be wrong even if it compiled since it would just
>>> > execute the assertion only when debug is disabled.
>>> >
>>> > --
>>> > Mateusz Guzik
>>> This is the mailing theme I am getting this from,[xhci] kernel BUG at
>>> include/linux/scatterlist.h:115.
>>> I hope this answers your question about the BUG_ON and yes I did
>>> compile check it with make
>>> M=include/. I also checked usb and usb net directories too.
>>
>> So how have you verified it tests you change? Why didn't you perform a
>> full build?
>>
>> This is a syntax error, I suggest you read up about C preprocessor.
>>
>> Your change attempts to flip the condition. Now virt_addr_valid(buf) is
>> tested only with debug disabled. When you enable debug it is suddenly
>> not tested - definitely does not make sense.
>>
>> I'm assuming you are talking about https://lkml.org/lkml/2014/7/30/810
>>
>> If you actually read the thread you will note:
>>> Looks like I either need specify valid addresses to sg_set_buf(), or
>>> just make the unit test depend on !CONFIG_DEBUG_SG.
>>
>> 1. It is acknowleged the problem is in the caller
>> 2. There is a suggestion to ensure that the UNIT TEST is not executed if
>> CONFIG_DEBUG_SG  is enabled (this part was shortened to "!CONFIG_DEBUG_SG"
>> but nobody claims you can use this in if/if[n]def statements)
>>
>> UNIT TEST as in the thingy which resulted in passing down a buffer
>> failing on this BUG_ON.
>>
>> There is no suggestion to do anything with sg_set_buf itself.
>>
>> You were advised several times to find a simpler project. Also people
>> noted that a "beginner kernel programmer" actually means "seasoned
>> programmer learning the kernel". It is clear you are not a seasoned
>> programmer, so why do you insist on doing kernel work?
>>
>> I can only recommend you play with userspace programs for now. These are
>> much easier to debug and experiment with, not to mention have a lot lower
>> entry point.
>>
>> --
>> Mateusz Guzik
> Mateusz,
> I am really losing my temper with people , when all you do is tell me to work on
> something else and don't even point me to how to build test in the kernel tree.
> Are you stating that your every fucking change I have to build the kernel over
> again, that is  a waste of time and you known it. Please stop telling me I can
> do this due to a few mistakes that you and the other developers are fucking
> over doing.
> Regards Nick


Matuesz,
My apologizes, I misread the message boards and this was my fault. Please stop
telling me to move away it's really get on my nerves.
Regards Nick
