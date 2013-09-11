Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3IKCwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:52:13 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56101 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3IKCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130911023026.GA6273@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com> <522D32F6.4020705@roeck-us.net>
 <20130909050147.GA3899@osiris> <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
 <20130911014443.GA20996@infradead.org> <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
 <20130911023026.GA6273@roeck-us.net>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 11 Sep 2013 10:51:50 +0800
Message-ID: <CA+a=Yy7+cj4Bw_4PArxMo2Manqp+aTVUi-7UcS+6-qNv7-RPyA@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:30 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Sep 11, 2013 at 10:25:57AM +0800, Peng Tao wrote:
>> On Wed, Sep 11, 2013 at 9:44 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Wed, Sep 11, 2013 at 01:14:11AM +0800, Peng Tao wrote:
>> >> The problem is access_process_vm() is not exported since certain
>> >> version of kernel including the latest. According to Christoph in the
>> >> other mail, access_process_vm() is also a core mm function that is not
>> >> supposed to be exported. Then what kind of change shall we make in
>> >> order to keep current functionality?
>> >
>> > You should remove the higher level functionality, kernel modules are
>> > not supposed to look at userspace environment variables.
>> >
>> OK. I've looked at the specific case that Lustre uses
>> access_process_vm() to get the jobid environment variable and package
>> it into the RPC requests to server. However, it turns out that in the
>> latest Lustre server code, the jobid in a request is not used
>> anywhere. So it looks like we can just get rid of it.
>>
>> Andreas, could you please confirm this? Is the jobid an obsolete
>> parameter that can be abandoned? Or is there plan to use it somehow in
>> the future?
>>
> "Plan to use it in the future" is not a reason or argument to keep it today,
> especially if it is something you are not supposed to do to start with.
> If you ever need it, you should be able to find some other means to
> support a similar functionality.
>
I'm not fighting against removing the piece of code. But if there is a
strong reason to keep the functionality, we need to find a way to
implement it. The convenience of using environment variables is that
job scheduler can set the environment and other existing applications
don't have to change. Are there other means to do the same? ioctl and
upcall both need application change AFAIK.

Again, if the code is just obsolete, which is quite likely but needs
Andreas' confirmation, we can just remove it.

Thanks,
Tao
