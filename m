Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaC0Rr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:47:56 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:53518 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaC0Rry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140326131800.GA7171@htj.dyndns.org>
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com>
	<20140314140804.GG12613@htj.dyndns.org>
	<CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com>
	<20140317201346.GE17373@mtj.dyndns.org>
	<5327AAA8.2080703@gmail.com>
	<53322777.3030703@gmail.com>
	<20140326131800.GA7171@htj.dyndns.org>
Date: Thu, 27 Mar 2014 13:47:53 -0400
Message-ID: <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to
 kern_mount() sysfs from sysfs_init()" prevents system from booting correctly
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll do my best, but I just don't have enough time right now for
everything I have to do at home and dig this bug. I may be able to
look at it in the next couple of days though, or it may go somewhere
next week... That being said, I tried yesterday to have a better idea
and I thank you for the "ScrLck" trick, I didn't know that it was
working. Nevertheless I didn't find anything.

It seems as if the transition from the temporary kernel's fs to the
hard disk's fs is not done correctly. If I boot with a working kernel
after that, I can't find any trace of where it was trying to copy the
files or of any partition being full. Could it be filling the RAM
until it reaches its maximum capacity (16GB to fill before hitting the
limit and throwing the errors)? That would explain at least why it
takes so much time before the flood of errors begins...

On Wed, Mar 26, 2014 at 9:18 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 25, 2014 at 09:03:51PM -0400, Alexandre Demers wrote:
>> So, I tried RC8 and I'm still getting the error. It start too fast
>> to be able to read whatever it is saying, but here is what I can
>> read:
>> ...
>> cp: error writing /run/initramfs/new_root/...
>> cp: failed to extend ...
>> ... (and so on)
>>
>> It goes on like that for a long time.
>
> Ooh, I thought you were gonna find out what filled up the filesystem
> after rebooting into the older kernel.  Can you please do that?  Also,
> pressing "ScrLk" should stop the screen from scrolling.
>
> Thanks.
>
> --
> tejun
