Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbaGQMfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:35:40 -0400
Received: from admin.comprocs.com ([12.186.155.30]:62982 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755396AbaGQMfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:35:37 -0400
X-BYPSHEADER: 2402942
X-SMScore: -200
Message-ID: <53C7C318.4000605@compro.net>
Date: Thu, 17 Jul 2014 08:35:36 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: DaeSeok Youn <daeseok.youn@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 6/8 V2] staging: dgap: remove unneeded dgap_err()
References: <20140715091144.GA19080@devel.8.8.4.4>	<20140715152929.GA8844@kroah.com>	<CAHb8M2B0EAjDr=yTfWQ_YsRcX9JumU8rUQ1mQeoqMWeBbY4gnQ@mail.gmail.com>	<20140715235058.GB32651@kroah.com>	<1528743817.342205.1405502782038.JavaMail.root@mx2.compro.net>	<53C68977.3020709@compro.net> <1745620693.361299.1405557767206.JavaMail.root@mx2.compro.net>
In-Reply-To: <1745620693.361299.1405557767206.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 08:42 PM, DaeSeok Youn wrote:
> 2014-07-16 23:17 GMT+09:00 Mark Hounschell <markh@compro.net>:
>> On 07/16/2014 05:26 AM, DaeSeok Youn wrote:
>>>
>>> 2014-07-16 8:50 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>>>
>>>> On Wed, Jul 16, 2014 at 08:21:30AM +0900, DaeSeok Youn wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> 2014-07-16 0:29 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>>>>>>
>>>>>> On Tue, Jul 15, 2014 at 06:11:44PM +0900, Daeseok Youn wrote:
>>>>>>>
>>>>>>> The dgap_err() is printing a message with pr_err(),
>>>>>>> so all those are replaced.
>>>>>>>
>>>>>>> Use definition "pr_fmt" and then all of "dgap:" in
>>>>>>> the beginning of print messages are removed.
>>>>>>>
>>>>>>> And also removed "out of memory" message because
>>>>>>> the kernel has own message for that.
>>>>>>>
>>>>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>>>>> ---
>>>>>>> V2: use pr_fmt "dgap:" prefix on print message on dgap.
>>>>>>>       remove "out of memory" message.
>>>>>>>
>>>>>>>       Adds Mark to TO list and CC list for checking send
>>>>>>>       this email properly to him.
>>>>>>>
>>>>>>>    drivers/staging/dgap/dgap.c |  306
>>>>>>> +++++++++++++++++++------------------------
>>>>>>>    1 files changed, 133 insertions(+), 173 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>>>>>>> index 06c55cb..9e750fb 100644
>>>>>>> --- a/drivers/staging/dgap/dgap.c
>>>>>>> +++ b/drivers/staging/dgap/dgap.c
>>>>>>> @@ -41,6 +41,8 @@
>>>>>>>     */
>>>>>>>    #undef DIGI_CONCENTRATORS_SUPPORTED
>>>>>>>
>>>>>>> +#define pr_fmt(fmt) "dgap: " fmt
>>>>>>> +
>>>>>>>    #include <linux/kernel.h>
>>>>>>>    #include <linux/module.h>
>>>>>>>    #include <linux/pci.h>
>>>>>>> @@ -153,7 +155,6 @@ static void dgap_firmware_reset_port(struct
>>>>>>> channel_t *ch);
>>>>>>>    static int dgap_gettok(char **in);
>>>>>>>    static char *dgap_getword(char **in);
>>>>>>>    static int dgap_checknode(struct cnode *p);
>>>>>>> -static void dgap_err(char *s);
>>>>>>>
>>>>>>>    /*
>>>>>>>     * Function prototypes from dgap_sysfs.h
>>>>>>> @@ -815,7 +816,7 @@ static struct board_t *dgap_found_board(struct
>>>>>>> pci_dev *pdev, int id,
>>>>>>>         if (ret)
>>>>>>>                 goto free_brd;
>>>>>>>
>>>>>>> -     pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
>>>>>>> +     pr_info("board %d: %s (rev %d), irq %ld\n",
>>>>>>>                 boardnum, brd->name, brd->rev, brd->irq);
>>>>>>
>>>>>>
>>>>>> Almost all of the pr_*() calls in this driver should be converted over
>>>>>> to use dev_*() calls instead.  And some of them, like this one, should
>>>>>> be removed entirely (no need for a driver to be "noisy" when a device
>>>>>> for it is found, it should be quiet if at all possible, unless
>>>>>> something
>>>>>> went wrong.)
>>>>>>
>>>>>> So can you do that here instead?  I've applied the earlier patches in
>>>>>> this series, and stopped here.
>>>>>
>>>>> OK. I can. pr_*() calls are replaced with dev_*() calls.
>>>>> And also removes some of print message which are useless like "out
>>>>> of memory"
>>>>
>>>>
>>>> Yes, please do that, that would be great.
>>>
>>> I have been working to change pr_*() to dev_*(), but dgap_parse() has no
>>>
>>> "struct device" for using dev_*(). If dgap_parse still need for this
>>> driver,
>>> it need to take a parameter for using dev_*(), it may be "pdev" but
>>> configuration
>>> file doesn't need to parse in kernel at all, dgap_parse() will be removed.
>>>
>>> So I will wait to verify by Mark about parsing configuration file.
>>>
>>> Thanks.
>>>
>>> regards,
>>> Daeseok Youn.
>>>
>>
>> Hi Daeseok,
>>
>> I would wait on that one for now. I know that code has to be removed
>> eventually. I'm just not sure if we are quite ready. That is actually a LOT
>> of lines of code also. I think a couple of things need done first.
>>
>> Here is a sample config file created by one of DIGI's user land applications
>> (mpi). These entries are only for 2 different cards. There are others cards
>> that may have other things to consider. I only have these 2 cards types now.
>> I had a third type which is just a 2 port but that one is gone now.
>>
>> config_begin
>> board   Digi_AccelePort_8r_920_PCI
>>          io 0x000
>>          mem 0x000000
>>          start 1
>>          nports 8
>>          ttyname ttya
>> altpin 0
>> useintr 0
>> board   Digi_AccelePort_4r_920_PCI
>>          io 0x000
>>          mem 0x000000
>>          start 1
>>          nports 4
>>          ttyname ttyb
>> altpin 0
>> useintr 0
>> board   Digi_AccelePort_8r_920_PCI
>>          io 0x000
>>          mem 0x000000
>>          start 1
>>          nports 8
>>          ttyname ttyc
>> altpin 0
>> useintr 0
>> config_end
>
> oh.. I couldn't find a sample of config file for dgap module in web. Thanks.
>
>>
>> The altpin and useintr parameters need to be converted to module parameters.
>> I found references in the code somewhere that the nports may not be reliably
>> known using the device id for at least one card type. All the other stuff in
>> this particular config file is pretty much useless. Well, sort of. The
>> ttyname parameter is used by the driver to populate a "sys" file with a
>> custom device name that is then used by a userland script and udev to allow
>> a user  to define his own device names. Custom links are created. Perhaps
>> this also would be nice to have as a module param?
>
> I'm not sure about using module param and udev. I think config file
> used when firmware
> is loaded.

The config file has nothing to do with the actual firmware loading or 
which firmware file is to be loaded for a given board. There are a 
couple of things done to the board either before or after firmware loads 
that probably still require that the config file had been parsed. 
Firmware loading for a particular board type is keyed off the 
firmware_info structure that correlates to the board_id structure.

> Is it possible to call dgap_firmware_load after init? It
> means dgap_firmware_load() calls by
> ioctl in user-land application with configuration data about board. If
> it has parameter for initialize this module, then use module param.
>

The original vanilla DIGI driver did use a user land application to load 
firmware. When the dgap_mgmt device was created, a udev file invoked 
this application that talked to the driver via ioctls to determine what 
firmware was needed, then to load it. All that code has already been 
removed from the driver and the firmware loading is done with in kernel 
methods that require no user land. There was also code removed between 
submission and actually arriving in staging that used the dgap_mgmt 
device for information gathering for user land. Currently the dgap_mgmt 
device is used for nothing. I haven't removed it because at some point I 
wanted to go back and see if some of that code, that was remove, might 
be appropriate for adding back into the driver. There was a whole slue 
of mgmt ioctls used by DIGI user land applications.

To get rid of the config file, all the things that dgap_parse sets up 
from the config file now need to be hard coded into the driver like the 
firmware files are done. The most important probably being nports. At 
least for the 2 board types I have. The device ID for all 
non-concentrator type boards can be used to determine nports. There are 
other things for other boards though. So every thing that dgap_parse can 
parse needs to be evaluated to determine, first if its needed at all, 
then, is there a reasonable default, and if NO reasonable default can be 
used, a module param should allow it's setting. For the board types I 
have, only altpin and useintr need to be configurable via a module 
param. In my usage of this driver only altpin and useintr are required. 
useintr is just whether to poll for interrupts or use the interrupt 
handler.  altpin, I believe just allows changing which signals are used 
for hardware flow control.

Also some of the config options deal with boards supporting 
concentrators. If we are not going to support those boards or their 
concentrators, a big chunk of dgap_parse goes away right off the bat.

Regards
Mark


