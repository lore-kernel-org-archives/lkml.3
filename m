Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3GZA7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:59:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28007 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3GZA7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:59:46 -0400
X-Spam-Score: -100.8
Message-ID: <51F1C9C4.2020205@asianux.com>
Date: Fri, 26 Jul 2013 08:58:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] kernel/irq/devres.c: move "kernel/irq/devres.c" to "drivers/base/devres_irq.c"
References: <51EE3264.7010801@asianux.com> <20130723153104.GD13949@kroah.com> <51EF34FF.8090102@asianux.com>
In-Reply-To: <51EF34FF.8090102@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the other mail thread, the related maintainer for s390 said:

  "s390 will have GENERIC_HARDIRQS soon (very likely next merge window)"

For efficiency reason, I should stop trying this issue any more.

  I found this issue by building s390 with allmodconfig, but s390 will be OK for this issue soon.
  If no direct cause, it is not a good idea to spend members expensive time resources only for one discussing.


Thanks.

On 07/24/2013 09:59 AM, Chen Gang wrote:
> On 07/23/2013 11:31 PM, Greg KH wrote:
>> On Tue, Jul 23, 2013 at 03:36:04PM +0800, Chen Gang wrote:
>>> "kernel/irq/devres.c" is a driver extension tool for irq (with devres)
>>> which is independent on 'GENERIC_HARDIRQS', so it is not suitable to
>>> still be in "kernel/irq/" which depends on 'GENERIC_HARDIRQS'.
>>>
>>> It is a basic tool for drivers, so can move it to "drivers/base/" to be
>>> independent on 'GENERIC_HARDIRQS'.
>>>
>>> It is about irq features, so if can not find other more suitable place,
>>> can still let their declaration in "include/linux/interrupts.h".
>>>
>>> The related error (with randconfig which disable 'GENERIC_HARDIRQS')
>>>
>>>   drivers/built-in.o: In function `dw_dma_probe':
>>>   (.text+0x3747a): undefined reference to `devm_request_threaded_irq'
>>
>> Don't fix problems when you are moving files around, that makes it
>> _very_ hard to review.
>>
> 
> OK, thanks, I should notice next time (originally, I really did not know
> about it).
> 
> Hmm... but for our case, if move the related file, it also can solve the
> related issue, it is only one action.
> 
>> Remember, one thing per patch please.
>>
> 
> OK, thanks, I will try (that may let me make more patches, which is not
> bad for myself ;-)).
> 
> 
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  drivers/base/Makefile     |    2 +-
>>>  drivers/base/devres_irq.c |   94 +++++++++++++++++++++++++++++++++++++++++++++
>>>  kernel/irq/Makefile       |    2 +-
>>>  kernel/irq/devres.c       |   94 ---------------------------------------------
>>>  4 files changed, 96 insertions(+), 96 deletions(-)
>>>  create mode 100644 drivers/base/devres_irq.c
>>>  delete mode 100644 kernel/irq/devres.c
>>
>> Please use git when renaming files so that the move is shown in the git
>> patch.  As it is, I would have to verify this by hand, and I don't want
>> to ever have to do that.
>>
> 
> Oh, thanks, I need use git to perform it (I should try to familiar with
> git).
> 
>> Also, I have no problem with the file being where it is.  This is for
>> irqs, which are handled by the interrupt maintainers, no need to put it
>> in the driver core, just because it happens to deal with "resources".
>> We arrange things for ease of maintainability, not always logically :)
>>
> 
> Hmm... normally, 'maintainability' has no conflict with 'logically', if
> we feel they are conflict, that means both of them need improvement.
> 
> For 'logically', is it suitable to move "resources" from "drivers/base"
> to "lib/", since they are already not only for drivers wide, but also
> for kernel wide ? (especially, some of "devm*" have already been in "lib/").
> 
> For 'maintainability', is it suitable to let "kernel/irq" independent on
> 'GENERIC_HARDIRQS' or "mv kernel/irq/devres.c kernel/devres_irq.c" ?
> 
> :-)
> 
> Thanks.
> 


-- 
Chen Gang
