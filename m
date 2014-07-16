Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaGPX71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:59:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61082 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaGPX7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <53C67285.4010008@compro.net>
References: <20140715091425.GA19095@devel.8.8.4.4>
	<790027403.325559.1405438239093.JavaMail.root@mx2.compro.net>
	<53C67285.4010008@compro.net>
Date: Thu, 17 Jul 2014 08:59:25 +0900
Message-ID: <CAHb8M2BOdRXeHXTaWbJgWyo3C+8LRHRGnMyoDD0rwMJD89TqWQ@mail.gmail.com>
Subject: Re: [PATCH 7/8 RESEND] staging: dgap: introduce dgap_cleanup_nodes()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Mark Hounschell <markh@compro.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

Thanks for reply.

2014-07-16 21:39 GMT+09:00 Mark Hounschell <markh@compro.net>:
> On 07/15/2014 11:30 AM, Greg KH wrote:
>>
>> On Tue, Jul 15, 2014 at 06:14:25PM +0900, Daeseok Youn wrote:
>>>
>>> When a configration file is parsed with dgap_parsefile(),
>>> makes nodes for saving configrations for board.
>>
>>
>> configuration files should not be parsed in the kernel at all.  That
>> logic should be removed as it should not be needed.
>>
>> Mark, can you verify that this is not needed with your hardware anymore?
>>
>
> As far as I can see it is still needed. If no config file, no devices are
> created and configured. I had planned to remove that code such that all the
> different cards supported are still supported. Even though I only have 2
> different types of cards. I Just haven't got to it yet. I realize
> "configuration files should not be parsed in the kernel" and I'm certainly
> not going to argue that. But the way it is, it allows user land to define
> board order and even device node names (additional links to the actual
> device). No matter where boards are installed and found by the kernel, you
> have persistent naming.  I guess all that can be done with udev (well, sort
> of anyway).
>
> There are also options in the config file that should be passed in as module
> parameters
> and I planned to do that part before messing with the config file code.
>
> We also have this "DIGI_EXPANDERS_SUPPORTED" thingy. I have none of these
> cards. These cards interrogate the expander to find out how many ports there
> are. Then configure accordingly. Should we just remove all that code and NOT
> support expanders since we don't currently have the hardware to test?
>
> I will update from your current git tree and test this week. I've been
> swamped lately and unable to do much. I thought I'd be available to do some
> more work but things come up as you know.
It need to have this patch when you start to test dgap module. This patch may be
cleaned up memory which are allocated in dgap_parse() when dgap fails
to init or unloads.

And I will send this patch again.

Thanks.
Daeseok Youn.
>
> Regards
> Mark
>
