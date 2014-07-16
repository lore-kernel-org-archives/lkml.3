Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbaGPORW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:17:22 -0400
Received: from admin.compro.net ([12.186.155.30]:50804 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934413AbaGPORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:17:17 -0400
X-BYPSHEADER: 1143638
X-SMScore: -200
Message-ID: <53C68977.3020709@compro.net>
Date: Wed, 16 Jul 2014 10:17:27 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: DaeSeok Youn <daeseok.youn@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 6/8 V2] staging: dgap: remove unneeded dgap_err()
References: <20140715091144.GA19080@devel.8.8.4.4> <20140715152929.GA8844@kroah.com> <CAHb8M2B0EAjDr=yTfWQ_YsRcX9JumU8rUQ1mQeoqMWeBbY4gnQ@mail.gmail.com> <20140715235058.GB32651@kroah.com> <1528743817.342205.1405502782038.JavaMail.root@mx2.compro.net>
In-Reply-To: <1528743817.342205.1405502782038.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 05:26 AM, DaeSeok Youn wrote:
> 2014-07-16 8:50 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> On Wed, Jul 16, 2014 at 08:21:30AM +0900, DaeSeok Youn wrote:
>>> Hi,
>>>
>>> 2014-07-16 0:29 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>>>> On Tue, Jul 15, 2014 at 06:11:44PM +0900, Daeseok Youn wrote:
>>>>> The dgap_err() is printing a message with pr_err(),
>>>>> so all those are replaced.
>>>>>
>>>>> Use definition "pr_fmt" and then all of "dgap:" in
>>>>> the beginning of print messages are removed.
>>>>>
>>>>> And also removed "out of memory" message because
>>>>> the kernel has own message for that.
>>>>>
>>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>>> ---
>>>>> V2: use pr_fmt "dgap:" prefix on print message on dgap.
>>>>>      remove "out of memory" message.
>>>>>
>>>>>      Adds Mark to TO list and CC list for checking send
>>>>>      this email properly to him.
>>>>>
>>>>>   drivers/staging/dgap/dgap.c |  306 +++++++++++++++++++------------------------
>>>>>   1 files changed, 133 insertions(+), 173 deletions(-)
>>>>>
>>>>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>>>>> index 06c55cb..9e750fb 100644
>>>>> --- a/drivers/staging/dgap/dgap.c
>>>>> +++ b/drivers/staging/dgap/dgap.c
>>>>> @@ -41,6 +41,8 @@
>>>>>    */
>>>>>   #undef DIGI_CONCENTRATORS_SUPPORTED
>>>>>
>>>>> +#define pr_fmt(fmt) "dgap: " fmt
>>>>> +
>>>>>   #include <linux/kernel.h>
>>>>>   #include <linux/module.h>
>>>>>   #include <linux/pci.h>
>>>>> @@ -153,7 +155,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
>>>>>   static int dgap_gettok(char **in);
>>>>>   static char *dgap_getword(char **in);
>>>>>   static int dgap_checknode(struct cnode *p);
>>>>> -static void dgap_err(char *s);
>>>>>
>>>>>   /*
>>>>>    * Function prototypes from dgap_sysfs.h
>>>>> @@ -815,7 +816,7 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
>>>>>        if (ret)
>>>>>                goto free_brd;
>>>>>
>>>>> -     pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
>>>>> +     pr_info("board %d: %s (rev %d), irq %ld\n",
>>>>>                boardnum, brd->name, brd->rev, brd->irq);
>>>>
>>>> Almost all of the pr_*() calls in this driver should be converted over
>>>> to use dev_*() calls instead.  And some of them, like this one, should
>>>> be removed entirely (no need for a driver to be "noisy" when a device
>>>> for it is found, it should be quiet if at all possible, unless something
>>>> went wrong.)
>>>>
>>>> So can you do that here instead?  I've applied the earlier patches in
>>>> this series, and stopped here.
>>> OK. I can. pr_*() calls are replaced with dev_*() calls.
>>> And also removes some of print message which are useless like "out
>>> of memory"
>>
>> Yes, please do that, that would be great.
> I have been working to change pr_*() to dev_*(), but dgap_parse() has no
> "struct device" for using dev_*(). If dgap_parse still need for this driver,
> it need to take a parameter for using dev_*(), it may be "pdev" but
> configuration
> file doesn't need to parse in kernel at all, dgap_parse() will be removed.
>
> So I will wait to verify by Mark about parsing configuration file.
>
> Thanks.
>
> regards,
> Daeseok Youn.
>

Hi Daeseok,

I would wait on that one for now. I know that code has to be removed 
eventually. I'm just not sure if we are quite ready. That is actually a 
LOT of lines of code also. I think a couple of things need done first.

Here is a sample config file created by one of DIGI's user land 
applications (mpi). These entries are only for 2 different cards. There 
are others cards that may have other things to consider. I only have 
these 2 cards types now. I had a third type which is just a 2 port but 
that one is gone now.

config_begin
board   Digi_AccelePort_8r_920_PCI
         io 0x000
         mem 0x000000
         start 1
         nports 8
         ttyname ttya
altpin 0
useintr 0
board   Digi_AccelePort_4r_920_PCI
         io 0x000
         mem 0x000000
         start 1
         nports 4
         ttyname ttyb
altpin 0
useintr 0
board   Digi_AccelePort_8r_920_PCI
         io 0x000
         mem 0x000000
         start 1
         nports 8
         ttyname ttyc
altpin 0
useintr 0
config_end

The altpin and useintr parameters need to be converted to module 
parameters. I found references in the code somewhere that the nports may 
not be reliably known using the device id for at least one card type. 
All the other stuff in this particular config file is pretty much 
useless. Well, sort of. The ttyname parameter is used by the driver to 
populate a "sys" file with a custom device name that is then used by a 
userland script and udev to allow a user  to define his own device 
names. Custom links are created. Perhaps this also would be nice to have 
as a module param?

Also, there is a userland utility (dpa) that is used to set some 
parameters of the card. Sort of like stty except it is for "special" 
things that the kernel does not directly support. Like special baud 
rates and such. I'm not sure what to do about that one. I personally 
have never used these "special" things but I'm sure they are used by 
someone somewhere?? I saw some code removed related to "dpa" recently. 
This came to mind.

Regards
Mark






