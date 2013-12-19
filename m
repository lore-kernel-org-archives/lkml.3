Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3LSQOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:14:49 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:59874 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LSQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:14:44 -0500
Message-ID: <52B32987.7070402@cogentembedded.com>
Date: Thu, 19 Dec 2013 20:14:47 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Rashika Kheria <rashika.kheria@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
References: <Pine.LNX.4.44L0.1312191043280.984-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312191043280.984-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/19/2013 06:45 PM, Alan Stern wrote:

>> Include header file include/linux/usb.h in include/linux/usb/hcd.h
>> because structures usb_device, usb_host_config and usb_interface have
>> their definitions in include/linux/usb.h.

>> This eliminates the following warning in include/linux/usb/hcd.h:
>> include/linux/usb/hcd.h:311:44: warning: ‘struct usb_device’ declared inside parameter list [enabled by default]
>> include/linux/usb/hcd.h:412:10: warning: ‘struct usb_host_config’ declared inside parameter list [enabled by default]
>> include/linux/usb/hcd.h:614:9: warning: ‘struct usb_interface’ declared inside parameter list [enabled by default]

    Rashika, would it be enough to forward-declare these structures ISO 
#include'ing the whole header?

> Where does this problem show up?
>
> Any file that include linux/usb/hcd.h should include linux/usb.h first.
> IMO it would be better to fix the source files that don't do the
> includes properly.

    Yeah, let's fix the consequency instead of the cause. :-)

> Of course, people have varying opinions on this issue.  As far as I
> know, there is no fixed policy in the kernel about nested includes.

    So far, I've only encountered the dubious policy of satisfying header's 
dependencies in the files that include them is the USB tree.

> Alan Stern

WBR, Sergei

