Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaGNCTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:19:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43581 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaGNCTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:19:05 -0400
X-AuditID: 85900ec0-d452db9000001514-81-53c33e156775
Message-ID: <53C33E15.7080504@hitachi.com>
Date: Mon, 14 Jul 2014 11:19:01 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Stephen Warren <swarren@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [PATCH V8 2/2] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
References: <20140530061617.21929.25777.stgit@yunodevel> <20140530061622.21929.82083.stgit@yunodevel> <20140710002837.GA5429@kroah.com> <20140710153157.57902972@alan.etchedpixels.co.uk> <20140710231637.GB9423@kroah.com> <20140712212237.GA7891@kroah.com>
In-Reply-To: <20140712212237.GA7891@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/13 6:22), Greg KH wrote:
> On Thu, Jul 10, 2014 at 04:16:37PM -0700, Greg Kroah-Hartman wrote:
>> On Thu, Jul 10, 2014 at 03:31:57PM +0100, One Thousand Gnomes wrote:
>>>> I really don't like the way that the tty core has been changed to handle
>>>> multiple attribute groups, as I feel tty drivers shouldn't be creating
>>>> "special" sysfs files, depending on what driver is bound to them.
>>>
>>> The intent isn't that it is "special" but that it can be propogated to
>>> others as and when they wish to provide it.
>>>
>>>> Usually we have handled this using tools like 'stty' and ioctls, right?
>>>> Surely there is an ioctl to control the interrupt level, right?  Hasn't
>>>> this been covered before somehow?
>>>
>>> No, and the direction when this started was to use sysfs as we have also
>>> been moving all the other attributes towards sysfs and has been since
>>> 2012.
>>>
>>> TTY devices do have lots of strange attributes and right now many of them
>>> are only programmable by using device tree and rebooting.
>>
>> Ok.  Hm, there has to be a better way to do the group sysfs file
>> handling...
>>
>> Let me work on this tomorrow and see what I can come up with.  We should
>> be able to use the is_visable() attribute to create/notcreate the
>> attribute where needed...
>
> Ok, how about this patch instead of your first one?
>
> It creates a new port attribute, attr_group, which you should be able to
> set in the 8250 driver if you device needs it.  Then the serial core
> will handle the dynamic group creation, without relying on a "magic"
> number of groups.  Very close to your patch, but now it's dynamic, and
> no fixed array, and no crazy casting in the
> tty_port_register_device_attr() call.

Thank you very much for your patch.
I'll use it as 1st patch in next version.

> I have not tested this, only test built the code.

OK, I'll test it.

> If it works for you, can you redo your second patch, and then send both
> of these back to me so that I can apply them?

Sure.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


