Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaJSN55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:57:57 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:47280 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaJSN5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:57:54 -0400
X-IronPort-AV: E=Sophos;i="5.04,749,1406617200"; 
   d="scan'208";a="48584596"
Message-ID: <5443C357.6050309@broadcom.com>
Date: Sun, 19 Oct 2014 15:57:43 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] debugfs: add helper function to create device related
 seq_file
References: <1413043315-22332-1-git-send-email-arend@broadcom.com> <20141011201723.GA29439@kroah.com> <543A382F.5060608@broadcom.com>
In-Reply-To: <543A382F.5060608@broadcom.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-14 10:13, Arend van Spriel wrote:
> On 11-10-14 22:17, Greg Kroah-Hartman wrote:
>> On Sat, Oct 11, 2014 at 06:01:55PM +0200, Arend van Spriel wrote:
>>> This patch adds a helper function that simplifies adding a
>>> sequence file for device drivers. The calling device driver
>>> needs to provide a read function and a device pointer. The
>>> field struct seq_file::private will reference the device
>>> pointer upon call to the read function so the driver can
>>> obtain his data from it and do its seq_printf() calls.
>>>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>>  fs/debugfs/file.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/debugfs.h | 16 ++++++++++++++-
>>>  2 files changed, 69 insertions(+), 1 deletion(-)
>>
>> Do you have some kernel code pending that needs this change?  Or can
>> existing users be moved to it, saving them code?
> 
> Yes and maybe. I made a similar change in our brcm80211 drivers, but
> figured it may be useful for other device drivers. So when this gets in
> the kernel I want to align the brcm80211 drivers. I will also have a
> quick look at the wireless drivers and get some metrics about code savings.

Hi, Greg

Killed a bit of time between lpc sessions in dusseldorf. I picked the
ath9k wireless driver as a test case. I made the changes in two steps.
First step was changing to use seq_file api and second step made use of
the helper function:

		original	seq_file	helper
logstat		-		173+/255-	32+/96-
ath9k.o		115968		113224		111024	(.text size)

I am considering to make an attempt at capturing the transition in a
SmPL script so it can be applied to other drivers as well. Have to do a
bit of self-study for that ;-)

Regards,
Arend

