Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3KLRlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:41:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47690 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3KLRlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:41:11 -0500
Message-ID: <52826706.2080508@arm.com>
Date: Tue, 12 Nov 2013 17:36:06 +0000
From: Jonathan Austin <Jonathan.Austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Axel Lin <axel.lin@ingics.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
References: <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com> <CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com> <CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com> <87y54vzszo.fsf@rustcorp.com.au> <CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com> <CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com> <CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com> <CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com> <CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com> <528110B1.4060402@arm.com>	<20131111193236.GB16735@n2100.arm.linux.org.uk> <CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
In-Reply-To: <CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
X-MC-Unique: 113111217363203902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 03:22, Ming Lei wrote:
> On Tue, Nov 12, 2013 at 3:32 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Mon, Nov 11, 2013 at 05:15:29PM +0000, Jonathan Austin wrote:
>>> I've tested the patch below and it solves the ARM side of things - so
>>> gives you an option other than a complete revert. Happy to put this in to
>>> RMK's patch system if you'd prefer not to have to revert and he's happy
>>> with the patch.
>>
>> I think this is the right solution because it then means that this symbol
>> has the same meaning whether on MMU or !MMU - and getting rid of these
>> kinds of gratuitous variances are the only way that !MMU is going to
>> become less fragile.
>
> The patch only fixes problem on arm, and other !MMU&&!ARM archs
> should be affected too.
>
> Also there is no CONFIG_PAGE_OFFSET defined for some ARCHs,
> such as 64bit ARCHs.
>
> Currently, I suggest to filter only on ARM as attachment patch if we plan
> to merge Jonathan's patch, otherwise a more complicated approach has
> to be figured out  to do the filter(such as, define a readonly symbol in
> kernel to store PAGE_OFFSET, and let scripts/kallsyms use it for
> filtering).

I'm happy with that approach, though allowing only ARM seems a bit
conservative - is it the only architecture we actually expect to work?

Jonny
>
>
>
> Thanks,
>


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

